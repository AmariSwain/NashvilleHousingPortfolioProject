/* 

Cleaning Nashville Housing Data in SQL Queries

*/

SELECT *
FROM PortfolioProject1.dbo.NashvilleHousing


------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Transforming Date into Standardized Format

SELECT SaleDateConverted
FROM PortfolioProject1.dbo.NashvilleHousing


UPDATE PortfolioProject1.dbo.NashvilleHousing
SET SaleDate =  CONVERT(Date, SaleDate);

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

UPDATE PortfolioProject1.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date, Saledate)


------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Populate Property Address Data

SELECT *
FROM PortfolioProject1.dbo.NashvilleHousing
---  WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject1.dbo.NashvilleHousing a
JOIN PortfolioProject1.dbo.NashvilleHousing b
		 on a.ParcelID = b.ParcelID
		 AND a.[UniqueID ] < > b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET  PropertyAddress =  ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject1.dbo.NashvilleHousing a
JOIN PortfolioProject1.dbo.NashvilleHousing b
		 on a.ParcelID = b.ParcelID
		 AND a.[UniqueID ] < > b.[UniqueID ]
WHERE a.PropertyAddress is null

------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Breaking Address into Individual Columns (Address, City, State) Using SUBSTRING

SELECT PropertyAddress
FROM PortfolioProject1.dbo.NashvilleHousing
---  WHERE PropertyAddress is null
-- ORDER BY ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX( ',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress,  CHARINDEX( ',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address

FROM PortfolioProject1.dbo.NashvilleHousing

ALTER TABLE PortfolioProject1.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

UPDATE PortfolioProject1.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX( ',', PropertyAddress) -1);

ALTER TABLE PortfolioProject1.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

UPDATE PortfolioProject1.dbo.NashvilleHousing
SET PropertySplitCity =  SUBSTRING(PropertyAddress,  CHARINDEX( ',', PropertyAddress) + 1, LEN(PropertyAddress))


SELECT *
FROM PortfolioProject1.dbo.NashvilleHousing

------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Breaking Address into Individual Columns (Address, City, State) Using PARSENAME


SELECT OwnerAddress
FROM PortfolioProject1.dbo.NashvilleHousing


SELECT 

 PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM PortfolioProject1.dbo.NashvilleHousing

ALTER TABLE PortfolioProject1.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

UPDATE PortfolioProject1.dbo.NashvilleHousing
SET OwnerSplitAddress =  PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3);

ALTER TABLE PortfolioProject1.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

UPDATE PortfolioProject1.dbo.NashvilleHousing
SET OwnerSplitCity =  PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2);

ALTER TABLE PortfolioProject1.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

UPDATE PortfolioProject1.dbo.NashvilleHousing
SET OwnerSplitState =  PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1);

SELECT *
FROM PortfolioProject1.dbo.NashvilleHousing

------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Changing "Y" & "N" to Yes & No in "Sold as Vacant" field

SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM PortfolioProject1.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'YES'
			  When SoldAsVacant = 'N' THEN 'NO'
			  ELSE SoldAsVacant
			  END
FROM PortfolioProject1.dbo.NashvilleHousing

UPDATE PortfolioProject1.dbo.NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'YES'
			  When SoldAsVacant = 'N' THEN 'NO'
			  ELSE SoldAsVacant 
			  END

------------------------------------------------------------------------------------------------------------------------------------------------------------
--Removing Dulpicates Using CTE

WITH RowNumCTE AS(
SELECT *,
		  ROW_NUMBER() OVER (
		  PARTITION BY ParcelID,
									  PropertyAddress,
									  SalePrice,
									  SaleDate,
									  LegalReference
									  ORDER BY 
											UniqueID
											) row_num

FROM PortfolioProject1.dbo.NashvilleHousing
--ORDER BY ParcelID
)
DELETE
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress

SELECT *
FROM PortfolioProject1.dbo.NashvilleHousing
------------------------------------------------------------------------------------------------------------------------------------------------------------
--Deleting Unused Columns

SELECT *
FROM PortfolioProject1.dbo.NashvilleHousing

ALTER TABLE PortfolioProject1.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress 

ALTER TABLE PortfolioProject1.dbo.NashvilleHousing
DROP COLUMN SaleDate



