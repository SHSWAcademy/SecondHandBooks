-- public.book_info definition

-- Drop table

-- DROP TABLE public.book_info;

CREATE TABLE public.book_info (
 book_info_seq int8 GENERATED ALWAYS AS IDENTITY( MINVALUE 0 NO MAXVALUE START 0 NO CYCLE) NOT NULL,
 isbn varchar(20) NOT NULL,
 book_title varchar(200) NOT NULL,
 book_author varchar(100) NULL,
 book_publisher varchar(100) NULL,
 book_img varchar(500) NULL,
 book_org_price int4 NULL,
 CONSTRAINT book_info_pkey PRIMARY KEY (book_info_seq)
);

-- public.member_info definition

-- Drop table

-- DROP TABLE public.member_info;

CREATE TABLE public.member_info (
 member_seq int8 GENERATED ALWAYS AS IDENTITY( MINVALUE 0 NO MAXVALUE START 0 NO CYCLE) NOT NULL,
 login_id varchar(50) NOT NULL,
 member_pwd varchar(255) NOT NULL,
 member_email varchar(100) NOT NULL,
 member_tel_no varchar(20) NULL,
 member_nicknm varchar(50) NOT NULL,
 member_deleted_dtm timestamp NULL,
 member_last_login_dtm timestamp NULL,
 member_st public."member_st_enum" NOT NULL,
 crt_dtm timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
 upd_dtm timestamp NULL,
 CONSTRAINT member_info_pkey PRIMARY KEY (member_seq)
);

-- public.book_club definition

-- Drop table

-- DROP TABLE public.book_club;

CREATE TABLE public.book_club (
 book_club_seq int8 GENERATED ALWAYS AS IDENTITY( MINVALUE 0 NO MAXVALUE START 0 NO CYCLE) NOT NULL,
 book_club_name varchar(100) NOT NULL,
 book_club_desc text NULL,
 book_club_rg varchar(50) NULL,
 book_club_max_member int4 NULL,
 book_club_deleted_dt date NULL,
 banner_img_url varchar(500) NULL,
 book_club_schedule varchar(200) NULL,
 crt_dtm timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
 upd_dtm timestamp NULL,
 book_club_leader_seq int8 NOT NULL,
 CONSTRAINT book_club_pkey PRIMARY KEY (book_club_seq),
 CONSTRAINT fk_book_club_leader FOREIGN KEY (book_club_leader_seq) REFERENCES public.member_info(member_seq)
);

-- public.book_club_board definition

-- Drop table

-- DROP TABLE public.book_club_board;

CREATE TABLE public.book_club_board (
 book_club_board_seq int8 GENERATED ALWAYS AS IDENTITY( MINVALUE 0 NO MAXVALUE START 0 NO CYCLE) NOT NULL,
 book_club_seq int8 NOT NULL,
 board_title varchar(200) NULL,
 board_cont text NULL,
 board_img_url varchar(500) NULL,
 board_deleted_yn bool NULL,
 board_deleted_dtm timestamp NULL,
 parent_book_club_board_seq int8 NOT NULL,
 member_seq int8 NOT NULL,
 book_info_seq int8 NOT NULL,
 CONSTRAINT book_club_board_pkey PRIMARY KEY (book_club_board_seq),
 CONSTRAINT fk_bcb_book FOREIGN KEY (book_info_seq) REFERENCES public.book_info(book_info_seq),
 CONSTRAINT fk_bcb_book_club FOREIGN KEY (book_club_seq) REFERENCES public.book_club(book_club_seq),
 CONSTRAINT fk_bcb_parent_board FOREIGN KEY (parent_book_club_board_seq) REFERENCES public.book_club_board(book_club_board_seq),
 CONSTRAINT fk_bcb_writer FOREIGN KEY (member_seq) REFERENCES public.member_info(member_seq)
);

-- public.book_club_member definition

-- Drop table

-- DROP TABLE public.book_club_member;

CREATE TABLE public.book_club_member (
 book_club_member_seq int8 GENERATED ALWAYS AS IDENTITY( MINVALUE 0 NO MAXVALUE START 0 NO CYCLE) NOT NULL,
 book_club_seq int8 NOT NULL,
 leader_yn bool NOT NULL,
 join_st public."join_st_enum" NULL,
 join_st_update_dtm timestamp NULL,
 member_seq int8 NOT NULL,
 CONSTRAINT book_club_member_pkey PRIMARY KEY (book_club_member_seq),
 CONSTRAINT uq_bcm_bookclub_member UNIQUE (book_club_seq,member_seq),
 CONSTRAINT fk_bcm_book_club FOREIGN KEY (book_club_seq) REFERENCES public.book_club(book_club_seq),
 CONSTRAINT fk_bcm_member FOREIGN KEY (member_seq) REFERENCES public.member_info(member_seq)
);

-- public.book_club_request definition

-- Drop table

-- DROP TABLE public.book_club_request;

CREATE TABLE public.book_club_request (
 book_club_request_seq int8 GENERATED ALWAYS AS IDENTITY( MINVALUE 0 NO MAXVALUE START 0 NO CYCLE) NOT NULL,
 book_club_seq int8 NOT NULL,
 request_cont text NULL,
 request_st public."request_st_enum" NOT NULL,
 request_dtm timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
 request_processed_dt date NULL,
 request_member_seq int8 NOT NULL,
 CONSTRAINT book_club_request_pkey PRIMARY KEY (book_club_request_seq),
 CONSTRAINT fk_bcr_book_club FOREIGN KEY (book_club_seq) REFERENCES public.book_club(book_club_seq),
 CONSTRAINT fk_bcr_request_member FOREIGN KEY (request_member_seq) REFERENCES public.member_info(member_seq)
);

-- public.book_club_wish definition

-- Drop table

-- DROP TABLE public.book_club_wish;

CREATE TABLE public.book_club_wish (
 book_club_wish_seq int8 GENERATED ALWAYS AS IDENTITY( MINVALUE 0 NO MAXVALUE START 0 NO CYCLE) NOT NULL,
 book_club_seq int8 NOT NULL,
 crt_dtm timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
 member_seq int8 NOT NULL,
 CONSTRAINT book_club_wish_pkey PRIMARY KEY (book_club_wish_seq),
 CONSTRAINT uq_bcw_bookclub_member UNIQUE (book_club_seq,member_seq),
 CONSTRAINT fk_bcw_book_club FOREIGN KEY (book_club_seq) REFERENCES public.book_club(book_club_seq),
 CONSTRAINT fk_bcw_member FOREIGN KEY (member_seq) REFERENCES public.member_info(member_seq)
);
