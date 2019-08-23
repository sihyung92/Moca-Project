/*����, �浵 ������ �Ÿ� ��� �Լ�*/
DELIMITER $$
DROP FUNCTION IF EXISTS `ST_Distance_Sphere`$$
CREATE FUNCTION `ST_Distance_Sphere` (point1 POINT, point2 POINT)
	RETURNS FLOAT
	no sql deterministic
	BEGIN
		declare R INTEGER DEFAULT 6371000;
		declare `��1` float;
		declare `��2` float;
		declare `�ĥ�` float;
		declare `�ĥ�` float;
		declare a float;
		declare c float;
		set `��1` = radians(y(point1));
		set `��2` = radians(y(point2));
		set `�ĥ�` = radians(y(point2) - y(point1));
		set `�ĥ�` = radians(x(point2) - x(point1));
		set a = sin(`�ĥ�` / 2) * sin(`�ĥ�` / 2) + cos(`��1`) * cos(`��2`) * sin(`�ĥ�` / 2) * sin(`�ĥ�` / 2);
		set c = 2 * atan2(sqrt(a), sqrt(1-a));
		return R * c;
	END$$
DELIMITER ;