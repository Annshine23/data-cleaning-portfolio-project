/*
Cleaning Data in SQL Queries
*/


Select *
From PortfolioProjects..Nashvillahousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select saledate, CONVERT(Date,SaleDate) as Saledateconverted
From PortfolioProjects.dbo.Nashvillahousing

update PortfolioProjects.dbo.Nashvillahousing
SET SaleDate = CONVERT(date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE NashvillaHousing
Add SaleDateConverted Date;

Update NashvillaHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From PortfolioProjects.dbo.NashvillaHousing
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProjects.dbo.NashvillaHousing a
JOIN PortfolioProjects.dbo.NashvillaHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProjects.dbo.NashvillaHousing a
JOIN PortfolioProjects.dbo.NashvillaHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From PortfolioProjects.dbo.NashvillaHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortfolioProjects.dbo.NashvillaHousing


ALTER TABLE PortfolioProjects.dbo.NashvillaHousing
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProjects.dbo.NashvillaHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE PortfolioProjects.dbo.NashvillaHousing
Add PropertySplitCity Nvarchar(255);

Update PortfolioProjects.dbo.NashvillaHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From PortfolioProjects.dbo.NashvillaHousing





Select OwnerAddress
From PortfolioProjects.dbo.NashvillaHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProjects.dbo.NashvillaHousing



ALTER TABLE PortfolioProjects.dbo.NashvillaHousing
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProjects.dbo.NashvillaHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE PortfolioProjects.dbo.NashvillaHousing
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProjects.dbo.NashvillaHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE PortfolioProjects.dbo.NashvillaHousing
Add OwnerSplitState Nvarchar(255);

Update PortfolioProjects.dbo.NashvillaHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortfolioProjects.dbo.NashvillaHousing



--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field



Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProjects.dbo.NashvillaHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProjects.dbo.NashvillaHousing


Update PortfolioProjects.dbo.NashvillaHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProjects.dbo.NashvillaHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProjects.dbo.NashvillaHousing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From PortfolioProjects.dbo.NashvillaHousing

ALTER TABLE PortfolioProjects.dbo.NashvillaHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate












