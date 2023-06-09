select * from chronic_diseases.sc_main;

# Top 10 highest weighted number of new cases (incidence) for the poorest population
select sc_def.social_class, sc_main.type_id as disease_type, disease_def.disease_group as diease_name, sc_main.weights as highest_weights
from chronic_diseases.sc_main
left join chronic_diseases.disease_def on sc_main.disease_group_id=disease_def.disease_group_id
left join chronic_diseases.sc_def on sc_main.sc_id = sc_def.sc_id
where sc_main.type_id = 2 and sc_main.sc_id = 1                                                 
order by sc_main.weights desc limit 10;
									   
# Top 10 highest weighted number of incidence cases for the wealthiest population
select sc_def.social_class, sc_main.type_id as disease_type, disease_def.disease_group as diease_name, sc_main.weights as highest_weights
from chronic_diseases.sc_main
left join chronic_diseases.disease_def on sc_main.disease_group_id=disease_def.disease_group_id
left join chronic_diseases.sc_def on sc_main.sc_id = sc_def.sc_id
where sc_main.type_id = 2 and sc_main.sc_id = 10                                                
order by sc_main.weights desc limit 10;

# How many weighted number of patients each disease group has at each profession. 
select dd.disease_group_id as "disease_id", dd.disease_group as "disease_group", pd.profession as "profession", 
sum(pm.weights) as "Number of weighted number"
from chronic_diseases.disease_def dd
inner join chronic_diseases.pro_main pm 
	on dd.disease_group_id = pm.disease_group_id
inner join chronic_diseases.pro_def pd
	on pm.job_id = pd.job_id
group by dd.disease_group_id, pd.profession
order by dd.disease_group_id asc;

# The average weighted number of patients of each disease at each education group.
select dd.disease_group_id as "disease_id", dd.disease_group as "disease_group", ed.education as "education", 
avg(em.weights) as "average_weights"
from chronic_diseases.disease_def dd
inner join chronic_diseases.edu_main em
	on dd.disease_group_id = em.disease_group_id
inner join chronic_diseases.edu_def ed
	on em.diploma_id = ed.diploma_id
group by dd.disease_group_id, dd.disease_group, ed.education
order by dd.disease_group asc;

# The highest total weighted number of patients by disease group and gender 
select a.disease_id, a.disease_group, max(a.total_weights) as max_total_weights, a.gender as "gender"
from
(
select dd.disease_group_id as "disease_id", dd.disease_group as "disease_group", sum(gm.weights) as "total_weights", gd.gender as "gender"
from chronic_diseases.disease_def dd
inner join chronic_diseases.gen_main gm
	on dd.disease_group_id = gm.disease_group_id
inner join chronic_diseases.gen_def gd
	on gm.gender_id = gd.gender_id
group by dd.disease_group_id, dd.disease_group, gd.gender
) as a
group by a.disease_id, a.disease_group, a.gender
order by max_total_weights desc;
