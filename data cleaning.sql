-- Data cleaning

Select *
From layoffs;


-- Remove Duplicates
-- Standardize the data
-- Null values or blank values
-- remove any columns that's not necessary


Create table layoffs_staging
Like Layoffs;

Select *
From layoffs_staging;

Insert layoffs_staging
Select *
from layoffs;


-- identify & remove duplicates

Select *,
Row_number() Over(partition by company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) As row_num
From layoffs_staging;

with duplicate_cte As
(Select *,
Row_number() Over(partition by company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) As row_num
From layoffs_staging)
Select *
from duplicate_cte
where row_num > 1;


Select *
From layoffs_staging
where company = 'oyster';


Select *,
Row_number() Over(partition by company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) As row_num
From layoffs_staging;

with duplicate_cte As
(Select *,
Row_number() Over(partition by company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) As row_num
From layoffs_staging)
delete 
from duplicate_cte
where row_num > 1;


-- the command above did not work because in MySQL, it is not possible to delete rows this way. Although this method is easier

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


Select *
from layoffs_staging2;

Insert into layoffs_staging2
(Select *,
Row_number() Over(partition by company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) As row_num
From layoffs_staging);

Select *
from layoffs_staging2
Where row_num > 1;

Delete 
from layoffs_staging2
Where row_num > 1;

SET SQL_SAFE_UPDATES = 0;
-- the above command was because the delete command did not occur because safe updates was turned off

Delete 
from layoffs_staging2
Where row_num > 1;

Select * 
from layoffs_staging2;

-- standardizing data


SELECT company, trim(company)
From layoffs_staging2;

Update layoffs_staging2
Set company = trim(company);


select distinct industry
from layoffs_staging2;

select distinct industry
from layoffs_staging2
order by 1;

-- to convert the date from text to date
select distinct location
from layoffs_staging2
order by 1;



select distinct country
from layoffs_staging2
order by 1;

Update layoffs_staging2
set country = Trim(Trailing '.' From country) 
where country like 'United States%';


select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;

update layoffs_staging2
set `date`= str_to_date(`date`, '%m/%d/%Y');

select `date`
from layoffs_staging2;

-- although the date column has been changed, the format is still text, to change that do the below. Also, only do this to your staging table not to the raw data


Alter table layoffs_staging2
modify column `date` date;


Select *
From layoffs_staging2;

-- dealing with null & blank values



Select *
From layoffs_staging2
where total_laid_off Is null
and percentage_laid_off Is null;

Delete
From layoffs_staging2
where total_laid_off Is null
and percentage_laid_off Is null;


Select *
from layoffs_staging2
where industry is null
or industry = '' ;


Select *
from layoffs_staging2
where company = 'Airbnb';

-- to see if it is possible to populate data on industry that is null or blank

Update layoffs_staging2
set industry= null
where industry = '';

Select t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
   on t1.company = t2.company
where (t1.industry Is Null or t1.industry = '');


Update layoffs_staging2 t1
join layoffs_staging2 t2
  on t1.company = t2.company
Set t1.industry = t2.industry
where t1.industry Is null
and t2.industry is not null;

-- in this case, we were not able to because the companies did not have other entries that have type of industry so there was nothing to populate from



-- to drop a colum from the table

alter table layoffs_staging2
drop column row_num;

Select *
from layoffs_staging2;

-- so this is the finalised cleaned data














