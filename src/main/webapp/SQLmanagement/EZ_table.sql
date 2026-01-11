CREATE TABLE member1 (
	memberIdx	NUMBER			NOT NULL PRIMARY KEY,
	nickName	VARCHAR2(50)	NOT NULL UNIQUE,
	userId		VARCHAR2(50)	NOT NULL UNIQUE,
	userPwd		VARCHAR2(20)	NOT NULL,
	userLevel	NUMBER			NOT NULL,
	enabled		NUMBER			NOT NULL,
	modify_date	DATE			NOT NULL,
	birth		DATE			NOT NULL,
	gender		VARCHAR2(6)		NOT NULL
);

CREATE TABLE member2 (
	memberIdx	NUMBER			NOT NULL PRIMARY KEY,
	userName	VARCHAR2(100)	NULL,
	email		VARCHAR2(100)	NULL,
	tel			VARCHAR2(20)	NULL
);

CREATE TABLE member3 (
	memberIdx		NUMBER			NOT NULL PRIMARY KEY,
	register_date	DATE			NULL,
	withdraw_date	DATE			NULL,
	withdraw_reason	VARCHAR2(255)	NULL
);

CREATE TABLE address (
	addr_id			NUMBER			NOT NULL PRIMARY KEY,
	memberIdx		NUMBER			NOT NULL,
	addr_name		VARCHAR2(50)	NULL,
	receiver_name	VARCHAR2(100)	NULL,
	receiver_tel	VARCHAR2(20)	NULL,
	zip_code		VARCHAR2(10)	NULL,
	addr1			VARCHAR2(100)	NULL,
	addr2			VARCHAR2(100)	NULL,
	isbasic			NUMBER(1)		NULL
);

CREATE TABLE login_history (
	log_id		VARCHAR2(20)	NOT NULL PRIMARY KEY,
	log_date	DATE			NULL,
	ip_info		VARCHAR2(30)	NULL,
	memberIdx	NUMBER			NOT NULL
);



CREATE TABLE reviews (
	order_id	VARCHAR2(20)	NOT NULL PRIMARY KEY,
	rating		NUMBER			NULL,
	content		VARCHAR2(2000)	NULL,
	img_url		VARCHAR2(2000)	NULL,
	reg_date	DATE			NULL
);


CREATE TABLE qna_answer (
	qna_id		NUMBER			NOT NULL PRIMARY KEY,
	memberIdx	NUMBER			NOT NULL,
	type		VARCHAR2(10)	NULL,
	title		VARCHAR2(50)	NULL,
	content		VARCHAR2(150)	NULL,
	answer_date	DATE			NULL
);

CREATE TABLE board_posts (
	post_id		NUMBER			NOT NULL PRIMARY KEY,
	board_type	VARCHAR2(20)	NULL,
	title		VARCHAR2(50)	NULL,
	content		VARCHAR2(255)	NULL,
	memberIdx	NUMBER			NOT NULL,
	reg_date	DATE			NULL,
	modify_date	DATE			NULL,
	views		NUMBER			NULL,
	thumbs_up	NUMBER			NULL,
	isfixed		NUMBER			NULL
);

CREATE TABLE qna_admin (
	qna_id	        NUMBER	        NOT NULL PRIMARY KEY,
	memberIdx	    NUMBER	        NOT NULL,
	answer_txt	    VARCHAR2(150)	NULL,
	answered_date	DATE	        NULL
);


-----------------------------------------------------------------

CREATE TABLE orders (
	order_id	        VARCHAR2(20)	NOT NULL PRIMARY KEY,
	memberIdx	        NUMBER	        NOT NULL,
	order_date	        DATE	        NULL,
	total_amount	    NUMBER	        NULL,
	real_total_amount	NUMBER	        NULL,
	point	            NUMBER	        NULL,
	status	            VARCHAR2(20)	NULL,
	delivery_number	    NUMBER	        NULL
);

CREATE TABLE claims (
	claim_id		NUMBER			NOT NULL PRIMARY KEY,
	order_id		VARCHAR2(20)	NOT NULL,
	type			VARCHAR2(10)	NULL,
	reason			VARCHAR2(1000)	NULL,
	req_date		DATE			NULL,
	process_date	DATE			NULL,
	status			VARCHAR2(20)	NULL
);

CREATE TABLE products (
	prod_id	        NUMBER			NOT NULL PRIMARY KEY,
	cate_code	    NUMBER			NOT NULL,
	prod_name	    VARCHAR2(200)	NULL,
	prod_desc	    CLOB			NULL,
	base_price	    NUMBER			NULL,
	is_displayed	NUMBER			NULL,
	thumb_nail	    VARCHAR2(255)	NULL,
	prod_date	    DATE			NULL,
	shipped_date	DATE			NULL
);

CREATE TABLE category (
	cate_code	NUMBER			NOT NULL PRIMARY KEY, 
	cate_name	VARCHAR2(50)	NULL,
	cate_parent	NUMBER			NOT NULL,
	depth		NUMBER			NULL
);


CREATE TABLE pd_color (
	prod_id	NUMBER	        NOT NULL PRIMARY KEY,
	img	    VARCHAR2(50)	NULL
);


CREATE TABLE pd_size (
	opt_id	NUMBER			NOT NULL PRIMARY KEY,
	prod_id	NUMBER			NOT NULL,
	size	VARCHAR2(50)	NULL
);

CREATE TABLE cart (
	cart_id		NUMBER	NOT NULL PRIMARY KEY,
	memberIdx	NUMBER	NOT NULL,
	prod_id		NUMBER	NOT NULL,
	opt_id		NUMBER	NOT NULL,
	quantity	NUMBER	NULL,
	reg_date	DATE	NULL
);

CREATE TABLE order_discounts (
	od_id			NUMBER			NOT NULL PRIMARY KEY,
	discount_amt	NUMBER			NULL,
	discount_id2	NUMBER			NOT NULL,
	order_id		VARCHAR2(20)	NOT NULL,
	item_id			NUMBER			NOT NULL
);

CREATE TABLE shipments (
	delivery_number		NUMBER			NOT NULL PRIMARY KEY,
	addr_id				NUMBER			NOT NULL,
	delivery_name		VARCHAR2(50)	NULL,
	delivery_tel		VARCHAR2(50)	NULL,
	delivery_personName	VARCHAR2(50)	NULL
);

CREATE TABLE product_img (
	prod_id	NUMBER			NOT NULL PRIMARY KEY,
	img		VARCHAR2(4000)	NULL
);

CREATE TABLE wishlist (
	wish_id		NUMBER		NOT NULL PRIMARY KEY,
	memberIdx	NUMBER		NOT NULL,
	prod_id		NUMBER		NOT NULL,
	isliked		NUMBER(1)	NULL
);

CREATE TABLE discounts (
	discount_id		NUMBER			NOT NULL PRIMARY KEY,
	discount_name	VARCHAR2(100)	NULL,
	type			VARCHAR2(10)	NULL,
	val				NUMBER			NULL,
	target_type		VARCHAR2(20)	NULL,
	target_id		NUMBER			NULL,
	start_date		DATE			NULL,
	end_date		DATE			NULL,
	is_active		NUMBER			NULL
);

CREATE TABLE point_member (
	pm_id			NUMBER			NOT NULL PRIMARY KEY,
	memberIdx		NUMBER			NOT NULL,
	order_id		VARCHAR2(20)	NOT NULL,
	change_type		VARCHAR2(20)	NULL,
	point_amount	NUMBER			NULL,
	rem_point		NUMBER			NULL,
	reg_date		DATE			NULL
);

CREATE TABLE payments (
	pay_id		NUMBER			NOT NULL PRIMARY KEY,
	pay_method	VARCHAR2(20)	NULL,
	pay_amount	NUMBER			NULL,
	pg_tid		VARCHAR2(100)	NULL,
	pay_status	VARCHAR2(20)	NULL,
	card_name	VARCHAR2(50)	NULL,
	card_num	VARCHAR2(50)	NULL,
	order_id	VARCHAR2(20)	NOT NULL
);

CREATE TABLE stock_logs (
	log_id		NUMBER			NOT NULL PRIMARY KEY,
	prod_id		NUMBER			NOT NULL,
	opt_id		NUMBER			NOT NULL,
	change_type	VARCHAR2(50)	NULL,
	change_qty	NUMBER			NULL,
	reg_date	DATE			NULL,
	prod_stock  NUMBER			NOT NULL
);

CREATE TABLE order_items (
	item_id		NUMBER			NOT NULL PRIMARY KEY,
	order_id	VARCHAR2(20)	NOT NULL,
	opt_id		NUMBER			NOT NULL,
	count		NUMBER			NULL,
	price		NUMBER			NULL
);







ALTER TABLE pd_color ADD CONSTRAINT PK_PD_COLOR PRIMARY KEY (
	prod_id
);

ALTER TABLE orders ADD CONSTRAINT PK_ORDERS PRIMARY KEY (
	order_id
);

ALTER TABLE products ADD CONSTRAINT PK_PRODUCTS PRIMARY KEY (
	prod_id
);

ALTER TABLE category ADD CONSTRAINT PK_CATEGORY PRIMARY KEY (
	cate_code
);

ALTER TABLE address ADD CONSTRAINT PK_ADDRESS PRIMARY KEY (
	addr_id
);

ALTER TABLE pd_size ADD CONSTRAINT PK_PD_SIZE PRIMARY KEY (
	opt_id
);

ALTER TABLE claims ADD CONSTRAINT PK_CLAIMS PRIMARY KEY (
	claim_id,
	order_id
);

ALTER TABLE member3 ADD CONSTRAINT PK_MEMBER3 PRIMARY KEY (
	memberIdx
);

ALTER TABLE reviews ADD CONSTRAINT PK_REVIEWS PRIMARY KEY (
	order_id
);

ALTER TABLE member1 ADD CONSTRAINT PK_MEMBER1 PRIMARY KEY (
	memberIdx
);

ALTER TABLE qna_answer ADD CONSTRAINT PK_QNA_ANSWER PRIMARY KEY (
	qna_id
);

ALTER TABLE cart ADD CONSTRAINT PK_CART PRIMARY KEY (
	cart_id
);

ALTER TABLE login_history ADD CONSTRAINT PK_LOGIN_HISTORY PRIMARY KEY (
	log_id
);

ALTER TABLE order_discounts ADD CONSTRAINT PK_ORDER_DISCOUNTS PRIMARY KEY (
	od_id
);

ALTER TABLE shipments ADD CONSTRAINT PK_SHIPMENTS PRIMARY KEY (
	delivery_number
);

ALTER TABLE member2 ADD CONSTRAINT PK_MEMBER2 PRIMARY KEY (
	memberIdx
);

ALTER TABLE wishlist ADD CONSTRAINT PK_WISHLIST PRIMARY KEY (
	wish_id
);

ALTER TABLE discounts ADD CONSTRAINT PK_DISCOUNTS PRIMARY KEY (
	discount_id
);

ALTER TABLE point_member ADD CONSTRAINT PK_POINT_MEMBER PRIMARY KEY (
	pm_id
);

ALTER TABLE board_posts ADD CONSTRAINT PK_BOARD_POSTS PRIMARY KEY (
	post_id
);

ALTER TABLE payments ADD CONSTRAINT PK_PAYMENTS PRIMARY KEY (
	pay_id
);

ALTER TABLE stock_logs ADD CONSTRAINT PK_STOCK_LOGS PRIMARY KEY (
	log_id
);

ALTER TABLE order_items ADD CONSTRAINT PK_ORDER_ITEMS PRIMARY KEY (
	item_id
);

ALTER TABLE qna_admin ADD CONSTRAINT PK_QNA_ADMIN PRIMARY KEY (
	qna_id
);


/*
ALTER TABLE pd_color ADD CONSTRAINT FK_products_TO_pd_color_1 FOREIGN KEY (
	prod_id
)
REFERENCES products (
	prod_id
);

ALTER TABLE claims ADD CONSTRAINT FK_orders_TO_claims_1 FOREIGN KEY (
	order_id
)
REFERENCES orders (
	order_id
);

ALTER TABLE member3 ADD CONSTRAINT FK_member1_TO_member3_1 FOREIGN KEY (
	memberIdx
)
REFERENCES member1 (
	memberIdx
);

ALTER TABLE reviews ADD CONSTRAINT FK_orders_TO_reviews_1 FOREIGN KEY (
	order_id
)
REFERENCES orders (
	order_id
);

ALTER TABLE member2 ADD CONSTRAINT FK_member1_TO_member2_1 FOREIGN KEY (
	memberIdx
)
REFERENCES member1 (
	memberIdx
);

ALTER TABLE qna_admin ADD CONSTRAINT FK_qna_answer_TO_qna_admin_1 FOREIGN KEY (
	qna_id
)
REFERENCES qna_answer (
	qna_id
);

