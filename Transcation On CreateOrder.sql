SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<YuXun-Lu>
-- Create date: <2014-5-24>
-- Description:	<ɾ�������ô洢����>
-- =============================================
CREATE PROCEDURE CreateNewOrder
	-- Add the parameters for the stored procedure here
	@OrderPrice FLOAT,
	@OrderUser UNIQUEIDENTIFIER,
	@OrderCourse UNIQUEIDENTIFIER,
	@OrderIsPaid BINARY,
	@Result BINARY OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-- һ�����������ع�
	SET XACT_ABORT ON;
	SET @Result = 0;
	-- ������
	BEGIN TRAN
		BEGIN TRY
			--���Ȳ���һ���µĶ�����¼
			INSERT INTO [ORDER]
			(order_id,ORDER_DATE,ORDER_PRICE,ORDER_ISPAID,ORDER_ISDELETED,ORDER_USER,ORDER_COURSE)
			 VALUES
			 (NEWID(),GETDATE(),@OrderPrice,@OrderIsPaid,0,@OrderUser,@OrderCourse);
			 
			--Ȼ���ڶ�Ӧ�û��˺����Ǯ
			UPDATE [USER]
			SET user_money = user_money - @OrderPrice
			WHERE
				user_id = @OrderUser;
				
			SET @Result = 1;
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK
		END CATCH	
		
END
GO
