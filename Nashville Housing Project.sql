USE NashVilleHousing 

-- Standardize  date format

SELECT SalesDateConverted, CONVERT(Date, SaleDate)
FROM NashvilleHousing

ALTER TABLE NashvilleHousing 
ADD SalesDateConverted Date;

UPDATE NashvilleHousing 
SET SalesDateConverted = CONVERT(Date, Saledate)

-- Populate Property Address data
SELECT *
FROM NashvilleHousing 
WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.ParcelID,a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
  ON a.ParcelID = b.ParcelID 
  AND a.[UniqueID ] <> b.[UniqueID ] 
WHERE a.PropertyAddress is NULL

-- Writting the update script 
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
  ON a.ParcelID = b.ParcelID 
  AND a.[UniqueID ] <> b.[UniqueID ] 
WHERE a.PropertyAddress is NULL

-- Breaking out Address into individual Columns (Address, City, State)
SELECT PropertyAddress,
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS City
FROM NashvilleHousing  

-- Doing the update
ALTER TABLE NashvilleHousing 
ADD PropertySplitAddress nvarchar(255);

UPDATE NashvilleHousing 
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

ALTER TABLE NashvilleHousing 
ADD PropertySplitCity nvarchar(255);

UPDATE NashvilleHousing 
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

SELECT * FROM NashVilleHousing

--  Other option to do the above

SELECT OwnerAddress
FROM NashvilleHousing

SELECT OwnerAddress,
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3),
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2),
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
FROM NashVilleHousing

-- Doing the update
ALTER TABLE NashvilleHousing 
ADD OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing 
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)

ALTER TABLE NashvilleHousing 
ADD OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousing 
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)

ALTER TABLE NashvilleHousing 
ADD OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing 
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)

SELECT * FROM NashvilleHousing 

-- Change Y and N to Yes and No in 'Sold as Vacant' filed
-- View distinct data 
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) 
FROM NashvilleHousing 
GROUP BY SoldAsVacant 
Order By 2

-- Soln

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END 
FROM NashvilleHousing 

-- The Update
UPDATE NashvilleHousing 
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END 
FROM NashvilleHousing 

-- Removing Duplcates
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
FROM NashvilleHousing
--ORDER BY ParcelID 
)
DELETE   -- SELECT *  
FROM RowNumCTE
WHERE row_num > 1
--Order by PropertyAddress


-- Delete unused Coloumns

SELECT * FROM NashvilleHousing

ALTER TABLE NashvilleHousing 
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

-- Ready and clean data