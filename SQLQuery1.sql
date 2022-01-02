SELECT TOP (1000) TransactionID
                , Postcode
                , First_Name
                , Last_Name
                , DOB
                , Street_1
                , Town_City
                , [State]
                , Amount
                , Existing_customerID
                , New_customerID1
                , New_customerID2
                , New_customerID3
FROM dbo.casestudy
ORDER BY New_customerID3;
--Postcode, State, 
WITH D1
     AS (SELECT Postcode
              , State
              , Town_City
              , Street_1
              , Last_Name
         FROM dbo.casestudy
         GROUP BY Postcode
                , State
                , Town_City
                , Street_1
                , Last_Name) ,
     D2
     AS (SELECT Postcode
              , State
              , Town_City
              , Street_1
              , Last_Name
              , ROW_NUMBER() OVER(
                ORDER BY Postcode
                       , State
                       , Town_City
                       , Street_1
                       , Last_Name) AS New_CUSID
         FROM D1)
UPDATE cs SET New_customerID1 = d.New_CUSID
     FROM dbo.casestudy cs
          JOIN D2 d
               ON ISNULL(cs.Postcode , '') = ISNULL(d.Postcode , '')
                  AND ISNULL(cs.State , '') = ISNULL(d.State , '')
                  AND ISNULL(cs.Town_City , '') = ISNULL(d.Town_City , '')
                  AND ISNULL(cs.Street_1 , '') = ISNULL(d.Street_1 , '')
                  AND ISNULL(cs.Last_Name , '') = ISNULL(d.Last_Name , '');


WITH D1
     AS (SELECT Postcode
              , State
              , Town_City
              , Street_1
              , Last_Name
              , First_Name
         FROM dbo.casestudy
         GROUP BY Postcode
                , State
                , Town_City
                , Street_1
                , Last_Name
                , First_Name) ,
     D2
     AS (SELECT Postcode
              , State
              , Town_City
              , Street_1
              , Last_Name
              , First_Name
              , ROW_NUMBER() OVER(
                ORDER BY Postcode
                       , State
                       , Town_City
                       , Street_1
                       , Last_Name
                       , First_Name) AS New_CUSID
         FROM D1)
UPDATE cs SET New_customerID2 = d.New_CUSID
     FROM dbo.casestudy cs
          JOIN D2 d
               ON ISNULL(cs.Postcode , '') = ISNULL(d.Postcode , '')
                  AND ISNULL(cs.State , '') = ISNULL(d.State , '')
                  AND ISNULL(cs.Town_City , '') = ISNULL(d.Town_City , '')
                  AND ISNULL(cs.Street_1 , '') = ISNULL(d.Street_1 , '')
                  AND ISNULL(cs.Last_Name , '') = ISNULL(d.Last_Name , '')
                  AND ISNULL(cs.First_Name , '') = ISNULL(d.First_Name , '');

WITH D1
     AS (SELECT Postcode
              , State
              , Town_City
           
              , Last_Name
              , Replace(Replace(Replace(First_Name,'@',''),'%',''),'^','') AS First_Name
         FROM dbo.casestudy
         GROUP BY Postcode
                , State
                , Town_City
              
                , Last_Name
                , Replace(Replace(Replace(First_Name,'@',''),'%',''),'^','')
				) ,
     D2
     AS (SELECT Postcode
              , State
              , Town_City
           
              , Last_Name
              , First_Name
              , ROW_NUMBER() OVER(
                ORDER BY Postcode
                       , State
                       , Town_City
                      
                       , Last_Name
                       , First_Name) AS New_CUSID
         FROM D1)
UPDATE cs SET New_customerID3 = d.New_CUSID
     FROM dbo.casestudy cs
          JOIN D2 d
               ON ISNULL(cs.Postcode , '') = ISNULL(d.Postcode , '')
                  AND ISNULL(cs.State , '') = ISNULL(d.State , '')
                  AND ISNULL(cs.Town_City , '') = ISNULL(d.Town_City , '')
                  AND ( ISNULL(cs.Last_Name , '') = ISNULL(d.Last_Name , '')
                        OR cs.Last_Name LIKE '%' + d.Last_Name
                        OR d.Last_Name LIKE '%' + cs.Last_Name )
                  AND ( ISNULL(cs.First_Name , '') = ISNULL(d.First_Name , '')
                        OR cs.First_Name LIKE '%' + d.First_Name
                        OR d.First_Name LIKE '%' + cs.First_Name );

