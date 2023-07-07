
# What are the top 5 brands by receipts scanned for most recent month?

SELECT
    name AS Brand_name,
    COUNT(*) AS scanned_receipts
FROM
    `Final` f
WHERE
    LEFT(dateScanned, 10) >= (
        SELECT MAX(LEFT(dateScanned, 10))
        FROM `Final` f
    ) - INTERVAL 1 MONTH
    AND LEFT(dateScanned, 10) < (
        SELECT MAX(LEFT(dateScanned, 10))
        FROM `Final` f
    ) + INTERVAL 1 DAY
GROUP BY
      Brand_name
ORDER BY
    scanned_receipts DESC
LIMIT 5;




# How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?

  
  WITH recent_month AS (
    SELECT
        name AS Brand_name,
        COUNT(*) AS recent_month_scanned_receipts
    FROM
        `Final` f
    WHERE
        LEFT(dateScanned, 10) >= (
            SELECT DATE_SUB(MAX(LEFT(dateScanned, 10)), INTERVAL 1 MONTH)
            FROM `Final` f
        )
        AND LEFT(dateScanned, 10) < (
            SELECT MAX(LEFT(dateScanned, 10))
            FROM `Final` f
        ) + INTERVAL 1 DAY
    GROUP BY
       Brand_name
),
previous_month AS (
    SELECT
        name AS Brand_name,
        COUNT(*) AS previous_month_scanned_receipts
    FROM
        `Final` f
    WHERE
        LEFT(dateScanned, 10) >= (
            SELECT DATE_SUB(MAX(LEFT(dateScanned, 10)), INTERVAL 2 MONTH)
            FROM `Final` f
        )
        AND LEFT(dateScanned, 10) < (
            SELECT DATE_SUB(MAX(LEFT(dateScanned, 10)), INTERVAL 1 MONTH)
            FROM `Final` f
        ) + INTERVAL 1 DAY
    GROUP BY
        Brand_name
)
SELECT
    recent_month.Brand_name,
    recent_month.recent_month_scanned_receipts,
    previous_month.previous_month_scanned_receipts
FROM
    recent_month
LEFT JOIN
    previous_month ON recent_month.Brand_name = previous_month.Brand_name
ORDER BY
    recent_month.recent_month_scanned_receipts DESC
LIMIT 5;



# When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?

SELECT
    CASE WHEN rewardsReceiptStatus = 'Finished' THEN 'ACCEPTED' ELSE rewardsReceiptStatus END AS rewardsStatus,
    AVG(totalSpent) AS average_spend
FROM
    export_receipts 
WHERE
    rewardsReceiptStatus IN ('Finished', 'Rejected')
GROUP BY
    rewardsStatus;
    
   
 # When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
   
SELECT
CASE WHEN rewardsReceiptStatus = 'Finished' THEN 'ACCEPTED' ELSE rewardsReceiptStatus END AS rewardsStatus,
    SUM(purchasedItemCount) AS total_items_purchased
FROM
    export_receipts er
WHERE
    rewardsReceiptStatus IN ('Finished', 'Rejected')
GROUP BY
    rewardsReceiptStatus;
   
   
   
   
# Which brand has the most spend among users who were created within the past 6 months?
   
          
SELECT
    name ,
   ROUND(SUM(totalSpent),2) AS total_spend
FROM
    `Final`
WHERE
    userId IN (
        SELECT userId
        FROM `Final`
        WHERE createdDate >= (
            SELECT MAX(createdDate) - INTERVAL 6 MONTH
            FROM `Final`
        )
    )
GROUP BY
   name 
ORDER BY
    total_spend DESC
LIMIT 5;


# Which brand has the most transactions among users who were created within the past 6 months?

    
SELECT
    name AS Brand_name ,
    COUNT(dateScanned) AS Total_Transactions
FROM
    `Final`
WHERE
    userId IN (
        SELECT userId
        FROM `Final`
        WHERE createdDate >= (
            SELECT MAX(createdDate) - INTERVAL 6 MONTH
            FROM `Final`
        )
    )
GROUP BY
   Brand_name
ORDER BY
    Total_Transactions DESC
LIMIT 5;




   
   
   

   