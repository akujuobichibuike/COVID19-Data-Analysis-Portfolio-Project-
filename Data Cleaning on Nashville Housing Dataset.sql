SELECT *
FROM NashvilleHousing

-- Converting the SalesDate to better format
SELECT SaleDate, CONVERT (Date, SaleDate) 
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT (Date, SaleDate)

ALTER TABLE NashvilleHousing
Add Sale_Date_Final Date;

UPDATE NashvilleHousing
SET Sale_Date_Final = CONVERT(Date, SaleDate)


-- Poulating the missing information in the Property Address Column
SELECT PropertyAddress
FROM NashvilleHousing
WHERE PropertyAddress IS NULL

SELECT *
FROM NashvilleHousing
WHERE PropertyAddress IS NULL

-- I noticed from the dataset that some property address came out as null which in my understanding shouldn't be, so to correct that I looked into the dataset and found a reference point to populate the missing property address. I found out that the ParcelID in some rows had the same Property Address which was what I used to populate the missing null values
 SELECT*
 FROM NashvilleHousing
 ORDER BY ParcelID

 SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
 FROM NashvilleHousing AS a
 JOIN NashvilleHousing AS b
   ON a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
 FROM NashvilleHousing AS a
 JOIN NashvilleHousing AS b
   ON a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


--Breaking out the Address into individual columns (Address, City, State)
-- Starting with Property Address
SELECT PropertyAddress
FROM NashvilleHousing

-- For this I used a substring
SELECT
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address
FROM NashvilleHousing

SELECT
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address
, SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM NashvilleHousing 


ALTER TABLE NashvilleHousing
Add PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitCity =  SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
FROM NashvilleHousing

-- Breaking out Owner Address into individual columns (Address, City, State)

SELECT OwnerAddress
FROM NashvilleHousing

 --For this one I used a parse name as it is much more convinent for delimited stuff than using substrings.

 SELECT 
 PARSENAME(REPLACE(OwnerAddress,',', '.'), 3),
 PARSENAME(REPLACE(OwnerAddress,',', '.'), 2),
 PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)
 FROM NashvilleHousing

 ALTER TABLE NashvilleHousing
Add OwnerSplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.'), 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)

SELECT *
FROM NashvilleHousing


-- Changing Y and N to Yes and No in the 'Sold as Vacant' column

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
       WHEN SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
       WHEN SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END



-- Remove Duplicates

--I used a CTE for this process

WITH RowNumCTE AS(
SELECT *,
    ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				  UniqueID
				  ) row_num

FROM NashvilleHousing
)
DELETE
FROM RowNumCTE
WHERE row_num > 1

--Deleting Unused Columns

--Not recommended as it's not ethically good to delete data from your DB 

SELECT *
FROM NashvilleHousing


ALTER TABLE NahvilleHousing
DROP COLUMN OwnerAddress, TaskDistrict, PropertyAdress, SaleDate