SELECT setseed(0.5);

CREATE TEMPORARY VIEW weighted_sigmc AS
SELECT 
  eid,
  Q.p,
  Q.r
FROM (SELECT 
        eid, 
        :scale * weight/(SELECT SUM(weight) FROM event_weights_sigmc) AS p,
        random() as r
      FROM event_weights_sigmc) AS Q
WHERE Q.r < Q.p;

CREATE TEMPORARY VIEW weighted_sigmc_specialized AS
SELECT 
  eid
FROM 
  weighted_sigmc INNER JOIN sample_assignments_sigmc USING (eid)
WHERE 
  sample_type = :sample_type;

CREATE TEMPORARY VIEW sigmc_ml_sample AS
SELECT *
FROM 
  weighted_sigmc_specialized INNER JOIN upsilon_candidates_sigmc USING (eid);

SELECT COUNT(*) FROM sigmc_ml_sample;
SELECT * FROM sigmc_ml_sample LIMIT 1;
