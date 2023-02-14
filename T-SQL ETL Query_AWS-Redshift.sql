delete dep304x_asm3_source_dbo.netflix_shows_clean;

COPY dep304x_asm3_source_dbo.netflix_shows_clean (show_id,type,title,director,"cast",country,date_added,release_year,rating,duration,listed_in,description)
FROM 's3://asm3-bucket/netflix_shows_clean.csv'
credentials 'aws_access_key_id=***;aws_secret_access_key=***'
CSV
IGNOREHEADER 1;

select * from dep304x_asm3_source_dbo.netflix_shows_clean
order by show_id;

delete dep304x_asm3_netflix_dw_dbo.dim_country_pro;
delete dep304x_asm3_netflix_dw_dbo.dim_date_pro;
delete dep304x_asm3_netflix_dw_dbo.dim_director_pro;
delete dep304x_asm3_netflix_dw_dbo.dim_duration_pro;
delete dep304x_asm3_netflix_dw_dbo.dim_info_pro;
delete dep304x_asm3_netflix_dw_dbo.dim_rating_pro;
delete dep304x_asm3_netflix_dw_dbo.dim_type_pro;
delete dep304x_asm3_netflix_dw_dbo.fact_netflix_show_pro;

call dep304x_asm3_netflix_dw_dbo.load_dim_country(1);
call dep304x_asm3_netflix_dw_dbo.load_dim_date(1);
call dep304x_asm3_netflix_dw_dbo.load_dim_director(1);
call dep304x_asm3_netflix_dw_dbo.load_dim_duration(1);
call dep304x_asm3_netflix_dw_dbo.load_dim_info(1);
call dep304x_asm3_netflix_dw_dbo.load_dim_rating(1);
call dep304x_asm3_netflix_dw_dbo.load_dim_type(1);
call dep304x_asm3_netflix_dw_dbo.load_fact_netflix_shows(1);
