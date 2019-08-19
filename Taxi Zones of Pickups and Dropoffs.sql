IF (SELECT OBJECT_ID('tempdb..#wav_trips')) IS NOT NULL DROP TABLE #wav_trips
SELECT
	[R].[hvfhs_license_num] as [HVFHV_License_num]
	--wait time
	,datediff(minute,[R].[request_datetime],[T].[on_scene_datetime]) as [r.request-t.on_scene_seconds]
	--request table
	,[R].[ride_id] as [r_ride_id]
	,[R].[originating_base_num] as [r_originating_base_num]
	,[R].[dispatching_base_num] as [r_dispatching_base_num]
	,[R].[hvfhs_license_num] as [r_HVFHV_License_num]
	,[R].[tlc_driver_license_num] as [r_tlc_driver_license_num]
	,[R].[license_plate] as [r_license_plate]
	,[R].[request_method] as [r_request_method]
	,[R].[request_datetime] as [r_request_datetime]
	,[R].[request_outcome] as [r_request_outcome]
	--trip record
	,[T].[ride_id] as [t_Ride_id]
	,[T].[originating_base_num] as [t_origination_base_num]
	,[T].[dispatching_base_num] as [t_dispatching_base_num]
	,[T].[hvfhs_license_num] as [t_HVFHV_License_num]
	,[T].[tlc_driver_license_num] as [t_tlc_driver_license_num]
	,[T].[license_plate] as [t_license_plate]
	,[T].[pickup_datetime] as [t_pickup_datetime]
	,[T].[on_scene_datetime] as [t_on_scene_datetime]
	,[T].[request_datetime] as [t_trip_request_datetime]
	,[T].[PULocationID] as [t_pulocation_id]
    ,[T].[DOLocationID] as [t_dolocation_id]
	,getdate() as [query_run_date]
INTO #wav_trips
FROM [TPEPDW].[dbo].[FHVHV_Request] as [R] inner join [TPEPDW].[dbo].[FHVHV_TripRecord] as [T] on [R].[ride_id] = [T].[ride_id]
WHERE
	left(ltrim(rtrim([r].[originating_base_num])),1)='B'
	and 
	left(ltrim(rtrim([r].[dispatching_base_num])),1)='B'
	and
	[r].[request_outcome] <> 3 
	and
	isdate([R].[request_datetime])=1
	and 
	isdate([T].[on_scene_datetime])=1
	and
	len([T].[hvfhs_license_num]) > 1
	and
	len([R].[hvfhs_license_num]) > 1

--======================================================================================================

--Top 5 Pickups
SELECT TOP 5 [t_pulocation_id], count([t_trip_request_datetime]) as [total]
FROM #wav_trips
WHERE datepart(m, [r_request_datetime]) = 6
GROUP BY [t_pulocation_id]
ORDER BY count([t_trip_request_datetime]) DESC


--Top 5 Dropoffs
SELECT TOP 5 [t_dolocation_id], count([t_trip_request_datetime]) as [total]
FROM #wav_trips
WHERE datepart(m, [r_request_datetime]) = 6
GROUP BY [t_dolocation_id]
ORDER BY count([t_trip_request_datetime]) DESC

--======================================================================================================

--Pickups
SELECT [borough], CASE
	WHEN [borough] = 'Manhattan' THEN sum([total]) 
	WHEN [borough] = 'Brooklyn' THEN sum([total]) 
	WHEN [borough] = 'Bronx' THEN sum([total]) 
	WHEN [borough] = 'Queens' THEN sum([total]) 
	WHEN [borough] = 'Staten Island' THEN sum([total]) 
	ELSE 0 END AS [total trips]
FROM (SELECT [t_pulocation_id], count([t_trip_request_datetime]) as [total],
CASE 
	WHEN [t_pulocation_id] in ('4','12','13','24','41','42','43','45','48','50','68','74','75','79','87','88','90','100','103','104',
		'105','107','113','114','116','120','125','127','128','137','140','141','142','143','144','148','151','152','153','158','161',
		'162','163','164','166','170','186','194','202','209','211','224','229','230','231','232','233','234','236','237','238','239',
		'243','244','246','249','261','262','263') THEN 'Manhattan'
	WHEN [t_pulocation_id] in ('3','18','20','31','32','46','47','51','58','59','60','69','78','81','94','119','126','136','147','159',
		'167','168','169','174','182','183','184','185','199','200','208','212','213','220','235','240','241','242','247','248','250',
		'254','259') THEN 'Bronx'
	WHEN [t_pulocation_id] in ('11','14','17','21','22','25','26','29','33','34','35','36','37','39','40','49','52','54','55','61','62',
		'63','65','66','67','71','72','76','77','80','85','89','91','97','106','108','111','112','123','133','149','150','154','155',
		'165','177','178','181','188','189','190','195','210','217','222','225','227','228','255','256','257') THEN 'Brooklyn'
	WHEN [t_pulocation_id] in ('2','7','8','9','10','15','16','19','27','28','30','38','53','56','57','64','70','73','82','83','86','92',
		'93','95','96','98','101','102','117','121','122','124','129','130','131','132','134','135','138','139','145','146','157','160',
		'171','173','175','179','180','191','192','193','196','197','198','201','203','205','207','215','216','218','219','223','226',
		'252','253','258','260') THEN 'Queens'
	WHEN [t_pulocation_id] in ('5','6','23','44','84','99','109','110','115','118','156','172','176','187','204','206','214','221','245',
		'251') THEN 'Staten Island'
	ELSE null END AS [borough]
FROM #wav_trips
WHERE datepart(m, [r_request_datetime]) = 6
GROUP BY [t_pulocation_id]) AS [1]
GROUP BY [borough]


--Dropoffs
SELECT [borough], CASE
	WHEN [borough] = 'Manhattan' THEN sum([total]) 
	WHEN [borough] = 'Brooklyn' THEN sum([total]) 
	WHEN [borough] = 'Bronx' THEN sum([total]) 
	WHEN [borough] = 'Queens' THEN sum([total]) 
	WHEN [borough] = 'Staten Island' THEN sum([total]) 
	ELSE 0 END AS [total trips]
FROM (SELECT [t_dolocation_id], count([t_trip_request_datetime]) as [total],
CASE 
	WHEN [t_dolocation_id] in ('4','12','13','24','41','42','43','45','48','50','68','74','75','79','87','88','90','100','103','104',
		'105','107','113','114','116','120','125','127','128','137','140','141','142','143','144','148','151','152','153','158','161',
		'162','163','164','166','170','186','194','202','209','211','224','229','230','231','232','233','234','236','237','238','239',
		'243','244','246','249','261','262','263') THEN 'Manhattan'
	WHEN [t_dolocation_id] in ('3','18','20','31','32','46','47','51','58','59','60','69','78','81','94','119','126','136','147','159',
		'167','168','169','174','182','183','184','185','199','200','208','212','213','220','235','240','241','242','247','248','250',
		'254','259') THEN 'Bronx'
	WHEN [t_dolocation_id] in ('11','14','17','21','22','25','26','29','33','34','35','36','37','39','40','49','52','54','55','61','62',
		'63','65','66','67','71','72','76','77','80','85','89','91','97','106','108','111','112','123','133','149','150','154','155',
		'165','177','178','181','188','189','190','195','210','217','222','225','227','228','255','256','257') THEN 'Brooklyn'
	WHEN [t_dolocation_id] in ('2','7','8','9','10','15','16','19','27','28','30','38','53','56','57','64','70','73','82','83','86','92',
		'93','95','96','98','101','102','117','121','122','124','129','130','131','132','134','135','138','139','145','146','157','160',
		'171','173','175','179','180','191','192','193','196','197','198','201','203','205','207','215','216','218','219','223','226',
		'252','253','258','260') THEN 'Queens'
	WHEN [t_dolocation_id] in ('5','6','23','44','84','99','109','110','115','118','156','172','176','187','204','206','214','221','245',
		'251') THEN 'Staten Island'
	ELSE null END AS [borough]
FROM #wav_trips
WHERE datepart(m, [r_request_datetime]) = 6
GROUP BY [t_dolocation_id]) AS [1]
WHERE [borough] <> 'NULL'
GROUP BY [borough]