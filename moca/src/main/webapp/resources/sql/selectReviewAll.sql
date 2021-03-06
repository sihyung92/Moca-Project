SELECT r.REVIEW_ID, r.ACCOUNTID, r.STOREID, r.REVIEWCONTENT, r.WRITEDATE, r.TASTELEVEL, 
	r.PRICELEVEL, r.SERVICELEVEL, r.MOODLEVEL, r.CONVENIENCELEVEL, r.LIKECOUNT, r.HATECOUNT, ifnull(l.ISLIKE,0) as 'ISLIKE',
	a.NICKNAME, a.FOLLOWCOUNT, a.REVIEWCOUNT
	FROM REVIEW r LEFT JOIN (SELECT * FROM LIKEHATE  WHERE ACCOUNT_ID = #{account_id}) l
	ON(r.REVIEW_ID = l.REVIEW_ID AND r.ACCOUNTID = l.ACCOUNT_ID)
	JOIN ACCOUNT a ON a.ACCOUNT_ID = r.ACCOUNTID
	WHERE r.STOREID = #{storeId};


--likeHate ����
DELETE FROM LIKEHATE WHERE LIKEHATE.REVIEW_ID = 1 AND LIKEHATE.ACCOUNT_ID = 1;