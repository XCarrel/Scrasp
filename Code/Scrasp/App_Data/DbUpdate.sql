USE Scrasp
GO

ALTER TABLE JobStates
	ADD allowClosure tinyint NULL, hideInDashboard tinyint NULL

GO

SET NOCOUNT ON
UPDATE JobStates SET allowClosure = 1 WHERE id=3; -- 'in progress'
UPDATE JobStates SET hideInDashboard = 1 WHERE id=4; -- 'finished'
SET NOCOUNT OFF
