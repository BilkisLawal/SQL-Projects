-- exploratory data analysis


Select *
from layoffs_staging2;


Select Max(total_laid_off), Max(percentage_laid_off)
from layoffs_staging2;

Select *
from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc;

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;