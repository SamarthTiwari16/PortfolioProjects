SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [ProjectPortfolio].[dbo].[NashvilleHousing]

select *
from ProjectPortfolio.dbo.NashvilleHousing

select saleDateConverted, convert(Date, SaleDate)
from ProjectPortfolio.dbo.NashvilleHousing

Update NashvilleHousing
set SaleDate = Convert(Date, SaleDate)

alter table NashvilleHousing
add saleDateConverted Date;

update NashvilleHousing
set saleDateConverted = convert(Date, SaleDate)

select *
from ProjectPortfolio.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelId

select a.ParcelId, a.PropertyAddress, b.ParcelId, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from ProjectPortfolio.dbo.NashvilleHousing a
join ProjectPortfolio.dbo.NashvilleHousing b
    on a.ParcelId = b.ParcelId
	and a.[UniqueId] <> b.[UniqueID]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from ProjectPortfolio.dbo.NashvilleHousing a
join ProjectPortfolio.dbo.NashvilleHousing b
    on a.ParcelId = b.ParcelId
	and a.[UniqueId] <> b.[UniqueID]
where a.PropertyAddress is null

select PropertyAddress
from ProjectPortfolio.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelId

select 
substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1) as Address
, substring(PropertyAddress, charindex(',', PropertyAddress) +1, len(PropertyAddress)) as Address
from ProjectPortfolio.dbo.NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress Nvarchar(255);

update NashvilleHousing
set PropertySplitAddress = substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1) 

alter table NashvilleHousing
add PropertySplitCity nvarchar(255);

update NashvilleHousing
set PropertySplitCity = substring(PropertyAddress, charindex(',', PropertyAddress) +1, len(PropertyAddress)) 

select *
from ProjectPortfolio.dbo.NashvilleHousing

select OwnerAddress
from ProjectPortfolio.dbo.NashvilleHousing

select
parsename(replace(OwnerAddress,',','.'), 3) as address
,parsename(replace(OwnerAddress,',','.'), 2) as city
,parsename(replace(OwnerAddress,',','.'), 1) as state
from ProjectPortfolio.dbo.NashvilleHousing

alter table NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

update NashvilleHousing
set OwnerSplitAddress = parsename(replace(OwnerAddress,',','.'), 3) 


alter table NashvilleHousing
add OwnerSplitCity nvarchar(255);

update NashvilleHousing
set PropertySplitCity = parsename(replace(OwnerAddress,',','.'), 2) 


alter table NashvilleHousing
add OwnerSplitState Nvarchar(255);

update NashvilleHousing
set OwnerSplitState = parsename(replace(OwnerAddress,',','.'), 1) 


select *
from ProjectPortfolio.dbo.NashvilleHousing

select Distinct(SoldAsVacant), count(SoldAsVacant)
from ProjectPortfolio.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
from ProjectPortfolio.dbo.NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
        when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end


with RowNumCTE as(
select *, 
    row_number() over(
	partition by ParcelId,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by
				     UniqueId
					 ) row_num
from ProjectPortfolio.dbo.NashvilleHousing
--order by ParcelId
)
select *
from RowNumCTE
where row_num > 1
order by PropertyAddress

select *
from ProjectPortfolio.dbo.NashvilleHousing 

alter table ProjectPortfolio.dbo.NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress

select *
from ProjectPortfolio.dbo.NashvilleHousing 

alter table ProjectPortfolio.dbo.NashvilleHousing
drop column SaleDate

select *
from ProjectPortfolio.dbo.NashvilleHousing