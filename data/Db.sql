create database HotelManager
go

use HotelManager
go

create table category_room(
	Id int not null identity(1,1) primary key,
	Name nvarchar(100) not null,
	Status bit,
	DateCreated datetime default(getDate())
)
go

create table room(
	Id int not null identity(1,1) primary key,
	Name nvarchar(100) not null,
	Price float not null,
	Acreage float not null,
	Img nvarchar(255) null,
	People int null,
	Note nvarchar(255) null,
	Status bit,
	CategoryRoom_id int not null,
	foreign key(CategoryRoom_id) references category_room(Id)
)
go

create table infrastructure(
	Id int not null identity(1,1) primary key,
	Name nvarchar(200) not null,
	Date datetime default(getDate()),
	Price float not null
)
go

create table infrastructure_room(
	Room_id int not null,
	Infrastructure_id int not null,
	Quantity int not null,
	DateCreated datetime default getDate()
	foreign key(Room_id) references room(Id),
	foreign key(Infrastructure_id) references infrastructure(Id),
)
go


create table role_group(
	Id int not null primary key identity(1,1),
	Id_group_role nvarchar(50),
	Name nvarchar(200),
	Note nvarchar(200)
)
go

INSERT INTO role_group (Id_group_role, Name, Note) VALUES
('MANAGER', N'Quản lý cấp cao', N'Có toàn quyền với chương trình.'),
('ADMIN', N'Quản trị chương trình', N'Có toàn quyền thay đổi dữ liệu, thêm mới người dùng, danh sách các đối tượng đang quản lý');
GO

create table department(
	Id int not null primary key identity(1,1),
	Id_department nvarchar(20),
	Name nvarchar(200),
	Note nvarchar(200)
)
go

INSERT INTO department (Id_department, Name, Note) VALUES
('PNS', N'Phòng nhân sự', N'Quản lý nhân sự'),
('PKT', N'Phòng kế toán', N'Quản lý kế toán'),
('PLT', N'Phòng lễ tân', N'Quản lý lễ tân')
GO

create table users(
	Id int not null identity(1,1) primary key,
	Username nvarchar(200) not null,
	Password nvarchar(200) not null,
	Img nvarchar(200) null,
	Name nvarchar(100),
	Phone nvarchar(100),
	Email nvarchar(100),
	Note nvarchar(100),
	Id_department int not null,
	Id_role_group int not null,
	foreign key(Id_department) references department(Id),
	foreign key(Id_role_group) references role_group(Id)
)
go

alter table users add Birthday date,
Gender int,
Address nvarchar(200),
Workday int,
Status int
go

INSERT INTO users (Id_department, Id_role_group, Username, [Password], Name, Phone, Email, Note, Img) VALUES
(1, 1, 'nthung', '123654', N'Nguyễn Thành Hưng', '0931695258', 'nthung2896@gmail.com', N'đsdsdsds',null)
GO

create table customer(
	Id int not null identity(1,1) primary key,
	Name nvarchar(200) not null,
	CardId int not null,
	Phone int not null,
	Sex bit,
	Address nvarchar(255) not null,
	Birthday Date,
	Status Bit,
	DateCreated Datetime default(getDate())
)
go

create table bill(
	Id int not null identity(1,1) primary key,
	Users_id int not null,
	Customer_id int not null,
	Total_money float ,
	DateCreated datetime default(getDate()),
	foreign key(Users_id) references users(Id),
	foreign key(Customer_id) references customer(Id)
)
go

create table bill_detail(
	Id int not null identity(1,1) primary key,
	Bill_id int not null,
	Room_id int not null,
	Price float not null,
	Note nvarchar(500),
	Surcharge float ,
	DateOfArrival Date,
	CheckOutDate Date,
	TotalMoney float 
	foreign key(Bill_id) references bill(Id),
	foreign key(Room_id) references room(Id)
)
go

create table service(
	Id int not null primary key identity(1,1),
	Name nvarchar(100) not null,
	Price float,
	DateCreated datetime default(getDate())
)
go

create table bill_detail_service(
	Service_id int not null,
	Billdetail_id int not null,
	Price float,
	DateCreated datetime default(getDate())
	foreign key(Service_id) references service(Id),
	foreign key(Billdetail_id) references bill_detail(Id)
)
go

update users set Gender = 0 where Id=1
go
update users set Birthday = null where Id=1
go

create proc user_update(
	@Id int,
	@Username nvarchar(200),
	@Password nvarchar(200),
	@Img nvarchar(200),
	@Name nvarchar(100),
	@Phone nvarchar(100),
	@Email nvarchar(100),
	@Note nvarchar(100),
	@Id_department int,
	@Id_role_group int,
	@Birthday date,
	@Gender int,
	@Address nvarchar(200),
	@Workday int,
	@Status int
)
as
begin
	update users set Username=@Username, Password=@Password, Img=@Img, 
		Phone=@Phone,Email=@Email, Note=@Note, Id_department=@Id_department,
		Id_role_group=@Id_role_group,Birthday=@Birthday, Gender=@Gender, 
		Address=@Address, Workday=@Workday, Status=@Status WHERE Id=@Id
end
go

create proc user_search_role(
	@whereValue int
)
as
begin
	select * from users where Id_role_group=@whereValue
end
go

create proc user_search_status(
	@status int
)
as
begin
	select * from users where Status=@status
end
go

create proc user_search_department(
	@Id_department int
)
as
begin
	select * from users where Id_department=@Id_department
end
go

create proc user_delete(
	@id int
)
as
begin
	DELETE FROM users WHERE Id=@id
end
go

create proc get_all_department
as
begin
	select * from department
end
go

create proc insert_department(
	@Id_department nvarchar(200),
	@Name nvarchar(200),
	@Note nvarchar(200)
)
as
begin
	insert into department values(@Id_department, @Name, @Note)
end
go

create proc update_department(
	@Id int,
	@Id_department nvarchar(200),
	@Name nvarchar(100),
	@Note nvarchar(200)
)
as
begin
	update department set Id_department=@Id_department, Name=@Name, Note=@Note where Id=@Id
end
go

create proc delete_department(
	@Id int
)
as
begin
	delete FROM department where Id=@Id
end
go


CREATE PROC infrastructure_insert
@name NVARCHAR(200),
@price FLOAT
AS
BEGIN
	INSERT INTO infrastructure(Name,Price)
	VALUES(@name,@price);
END
GO
CREATE PROC infrastructure_select
AS
BEGIN
	SELECT * FROM infrastructure;
END
GO
CREATE PROC infrastructure_selectById
@id INT
AS
BEGIN
	SELECT * FROM infrastructure WHERE id = @id;
END
GO
CREATE PROC infrastructure_update
@id INT,
@name NVARCHAR(200),
@price FLOAT
AS
BEGIN
	UPDATE infrastructure
	SET Name =@name,Price = @price
	WHERE Id = @id;
END
GO
CREATE PROC infrastructure_delete
@id INT
AS
BEGIN
	DELETE FROM infrastructure WHERE Id = @id ;
END
GO

CREATE PROC service_insert
@name NVARCHAR(200),
@price FLOAT
AS
BEGIN
	INSERT INTO service(Name,Price)
	VALUES(@name,@price);
END
GO
CREATE PROC service_select
AS
BEGIN
	SELECT * FROM service;
END
GO
CREATE PROC service_selectById
@id INT
AS
BEGIN
	SELECT * FROM service WHERE id = @id;
END
GO
CREATE PROC service_update
@id INT,
@name NVARCHAR(200),
@price FLOAT
AS
BEGIN
	UPDATE service
	SET Name =@name,Price = @price
	WHERE Id = @id;
END
GO
CREATE PROC service_delete
@id INT
AS
BEGIN
	DELETE FROM service WHERE Id = @id ;
END
GO


CREATE PROC insertcrb(@name nvarchar(100), @status bit)
as
begin
INSERT INTO category_room(Name, Status) VALUES (@name, @status)
end
go
CREATE PROC updatecrb(@name nvarchar(100),@status bit,@id int)
as
begin
UPDATE category_room 
SET Name = @name, Status = @status where Id = @id
end
GO
CREATE PROC deletecrb(@id int)
as
begin
DELETE FROM category_room where Id = @id
end
go
CREATE PROC getdatacrb
AS
BEGIN
	SELECT * FROM category_room
END
GO

create proc get_id_by_name_cateRoom(
	@nameCate nvarchar(200)
)
as
begin
	select * from category_room where Name=@nameCate
end
go




create proc insertRoom(
	@name nvarchar(200),
	@price float,
	@acreage float,
	@img nvarchar(200),
	@people int,
	@note nvarchar(500),
	@status int,
	@categoryRoom int,
	@id int output
)
as
begin
	insert into dbo.room(Name,Price,Acreage,Img,People,Note,Status,CategoryRoom_id) values(@name, @price, @acreage, @img, @people, @note, @status, @categoryRoom)
	set @id = SCOPE_IDENTITY()
	SELECT @id as N'Id New Insert'
end
go

create proc selectAllRoom
as
begin
	select * from room
end 
go

create proc select_room_by_id(
	@id int
)
as
begin
	select * from room where Id=@id
end
go

create proc select_room_by_cate_status_price(
	@cateRoomId int,
	@status int,
	@num1 float, 
	@num2 float
)
as
begin
	select * from room where CategoryRoom_id=@cateRoomId and Status=@status and Price BETWEEN @num1 AND @num2
end
go

create proc update_room(
	@id int,
	@name nvarchar(200),
	@price float,
	@acreage float,
	@img nvarchar(200),
	@people int,
	@note nvarchar(500),
	@status int,
	@category_id int
)
as
begin
	update room set Name=@name,Price=@price,Acreage=@acreage,Img=@img,People=@people,Note=@note,
	Status=@status, CategoryRoom_id=@category_id where Id=@id
end
go

create proc delete_room(
	@id int
)
as
begin
	delete from room where Id=@id
	
end
go

create proc search_room_id(
	@id nvarchar(200)
)
as
begin
	select * from room where Id like N'%'+@id+'%'
end
go

create proc search_room_name(
	@name nvarchar(200)
)
as
begin
	select * from room where Name like N'%'+@name+'%'
end
go

create proc search_room_cateRoom(
	@id int
)
as
begin
	select * from room where CategoryRoom_id=@id
end
go

create proc search_room_Status(
	@id int
)
as
begin
	select * from room where Status=@id
end
go


create proc insert_infrastructure_room(
	@room_id int,
	@infrastructure_id int,
	@quantity int
)
as
begin
	insert into infrastructure_room(Room_id,Infrastructure_id,Quantity) values(@room_id, @infrastructure_id, @quantity)
end
go

create proc select_name_infras_by_id_room(
	@id int
)
as
begin
	select infrastructure.Name, infrastructure_room.Quantity from infrastructure_room inner join infrastructure on infrastructure_room.Infrastructure_id = infrastructure.Id 
	where infrastructure_room.Room_id = @id
end
go

create proc update_infras_room(
	@id int,
	@infrastructure int, 
	@quantity int
)
as
begin
	update infrastructure_room set Quantity=@quantity where Room_id=@id and Infrastructure_id=@infrastructure
end
go

create proc select_count_by_id_room(
	@id int
)
as
begin
	select count(Room_id) as N'Số Bản Ghi' from infrastructure_room where Room_id=@id
end
go

create proc delete_infras_room_by_roomid(
	@id int
)
as
begin
	DELETE FROM infrastructure_room WHERE Room_id = @id ;
end
go













CREATE PROC getIdByUser
@user NVARCHAR(200)
AS
BEGIN
	SELECT Id FROM users WHERE Username = @user;
END
GO
CREATE PROC customer_insert
@name NVARCHAR(200),
@cardId INT,
@phone INT,
@sex INT,
@address NVARCHAR(200),
@birthday DATE,
@status INT,
@Id INT OUTPUT
AS
BEGIN
	INSERT INTO customer(Name,CardId,Phone,Sex,Address,Birthday,Status)
	VALUES(@name,@cardId,@phone,@sex,@address,@birthday,@status);
	SET @Id = SCOPE_IDENTITY()
	SELECT @Id as N'Id New Insert'
END
GO
CREATE PROC bill_insert
@user_id int ,
@customer_id int ,
@total_moneny FLOAT,
@id int OUTPUT
AS
BEGIN
	INSERT INTO bill(Users_id,Customer_id,Total_money)
	VALUES(@user_id,@customer_id,@total_moneny);
	SET @id = SCOPE_IDENTITY();
END
GO
CREATE PROC bill_update_moneny
@id INT,
@total_moneny FLOAT
AS
BEGIN
	UPDATE bill
	SET Total_money = @total_moneny
	WHERE Id =@id;
END
GO
CREATE PROC billDetail_insert
	@bill_id INT,
	@room_id INT,
	@price FLOAT,
	@note NVARCHAR(200),
	@Surcharge FLOAT,
	@dateOfArrival DATE,
	@checkOutDate DATE,
	@totalMoney FLOAT,
	@status BIT,
	@id int OUTPUT
AS
BEGIN
	INSERT INTO bill_detail(Bill_id,Room_id,Price,Note,Surcharge,DateOfArrival,CheckOutDate,TotalMoney,Status)
	VALUES(@bill_id,@room_id,@price,@note,@Surcharge,@dateOfArrival,@checkOutDate,@totalMoney,@status);
	SET @id = SCOPE_IDENTITY();
END
GO
CREATE PROC bill_detail_service_insert
@service_id INT,
@billdetail_id INT,
@price FLOAT
AS
BEGIN
	INSERT INTO bill_detail_service(Service_id,Billdetail_id,Price)
	VALUES(@service_id,@billdetail_id,@price);
END
GO
CREATE PROC customser_remove
@id INT 
AS
BEGIN
	DELETE FROM customer WHERE Id = @id;
END
GO
CREATE PROC bill_remove
@id INT 
AS
BEGIN
	DELETE FROM bill WHERE Id = @id;
END
GO
CREATE PROC billDetail_remove
@id INT 
AS
BEGIN
	DELETE FROM bill_detail WHERE Id = @id;
END
GO
CREATE PROC billDetailService_remove
@service_id INT,
@billdetail_id INT
AS
BEGIN
	DELETE FROM bill_detail_service WHERE Service_id = @service_id AND Billdetail_id = @billdetail_id;
END
GO

