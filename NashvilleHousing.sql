select *
from PortfolioProject.dbo.NashvilleHousing

--standardize data format
select SaleDateConverted
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SaleDate = convert(date,SaleDate)

alter table NashvilleHousing
add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted = convert(Date,SaleDate)

--populate property adress data
select *
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID


select a.ParcelID,a.PropertyAddress, b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ] <>b.[UniqueID ]
 where a.PropertyAddress is null


 update a
 set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
 from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ] <>b.[UniqueID ]
 where a.PropertyAddress is null

--braking out adress into individual columns (adress, city, state)

select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select 
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)) as address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress)) as address

from PortfolioProject.dbo.NashvilleHousing


alter table NashvilleHousing
add PropertySplitAddress nvarchar(255);

update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)

alter table NashvilleHousing
add PropertySplitCity nvarchar(255);

update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress))

select * 
from NashvilleHousing

select OwnerAddress
from NashvilleHousing

-- change Y and N TO YES and NO in "Solid as Vacant" field

select distinct(SoldAsVacant),count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant

select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from PortfolioProject..NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end



--delete unused columns

select * 
from PortfolioProject..NashvilleHousing
 
alter table PortfolioProject.dbo.NashvilleHousing
Drop column OwnerAddress, TaxDistrict,PropertyAddress

alter table PortfolioProject.dbo.NashvilleHousing
drop column SaleDate