<%@ page contentType="text/html; charset=UTF-8" %>
<!-- JSP의 인코딩 방식 선언 ==> UTF-8 ==> 한글 깨지지 않도록 지정 -->
<%@ page import="java.sql.*, javax.sql.*, java.io.*" %>
<!-- 사용할 라이브러리 import -->
 <html>
 <head>
   <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
 </head>
 <body>
   <style>
      body{
         background-image: url('./vote.png');
      }
      
      #container {
         border: 5px solid green;
         border-spacing: 5%;
         width: 90%;
         margin-top: 5%;
         margin-left: auto;
         margin-right: auto;
         background-color: white;
         opacity: 0.98;
      }
      
      #menu{
         display: inline-block;
         border:3px black solid;
         width:20%;
         margin: 1%;
         text-align: center;
         font-size: 30px;
         box-shadow: 2px 2px 4px 2px #dadce0;
      }
      
      .menu_result{
         background-color: yellow;
      }
      
      #do_vote {
         width: 95%;
         margin-left: auto;
         margin-right: auto;
         cellspacing: 0;
         font-size: 20px;
      }
      #each_result_ageGroup{
         border: 1px solid black;
         font-size: 25px;
         width:15%;
      }
      #each_result_bar{
         border: 1px solid black;
         font-size: 25px;
         width:90%;
      }
      
      #small_title{
         width: 100%:
         text-align: left;
         font-size: 30px;
         margin: 1%;
      }

   </style>
   
   <div id=container>
   <br>
         <div onclick="location.href='./A_01.jsp'" id="menu" class="menu_enroll">후보등록</div>
         <div onclick="location.href='./B_01.jsp'" id="menu" class="menu_vote">투표</div>
         <div onclick="location.href='./C_01.jsp'" id="menu" class="menu_result">개표결과</div>
         <br>
         <br>
         <form method=post action="./C_02.jsp">
         <%
            int get_number = Integer.parseInt(request.getParameter("get_number"));
            String get_name = request.getParameter("get_name");
            
            out.println("<div id=small_title>"+get_number+"번 "+get_name+" 후보 득표 성향 분석</div>");
            
            // 데이터베이스 연결
            Class.forName("com.mysql.cj.jdbc.Driver");      //JDBC 드라이버 로드
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo08","root","root");
                                                //127.0.0.1 = localhost
            
            // 선택 후보 상세 데이터(연령별 득표율)
            Statement stmt1 = conn.createStatement();      // Statement(sql 쿼리 전달) 변수에 database연결-명령어 저장;
            ResultSet rset1 = stmt1.executeQuery("select age_group, count(age_group) from Tupyo_table where number="+get_number+" group by age_group order by age_group asc;");   
            // 1. age_group 2. age_group별 득표수
                                          
            // 선택 후보 상세 데이터(연령별 득표율) 데이터 저장용 테이블 생성;
            Statement stmt2 = conn.createStatement();
            stmt2.execute("drop table if exists vote_detail;");
            stmt2.execute("create table vote_detail (age_group int primary key, vote int, vote_total int);");
            
            // 초기 데이터 넣기
            for (int i = 1; i < 10; i++) {
               String QueryTxt1 = String.format("insert into vote_detail values ("+i+",0,0);");
               stmt2.execute(QueryTxt1);
            }
            
            // vote_detail( 선택 후보의 상세 득표 경향 ) 테이블 업데이트 ==> 선택 후보 연령별 득표 수
            while (rset1.next()) {
               String QueryTxt2 = String.format("UPDATE vote_detail SET vote="+rset1.getInt(2)+" WHERE age_group="+rset1.getInt(1)+";");
               stmt2.execute(QueryTxt2);
            }
            
            // vote_detail( 선택 후보의 상세 득표 경향 ) 테이블 업데이트 ==> 선택 후보 총 득표 수
            stmt2.execute("UPDATE vote_detail SET vote_total=(select count(*) from Tupyo_table as b where b.number="+get_number+");");
            
            // vote_detail( 선택 후보의 상세 득표 경향 ) 테이블 ==> 정보 읽어오기 : 1. age_group 2. vote(해당 해보/해당 나이대) 3. vote_total (해당 후보 전체)
            Statement stmt3 = conn.createStatement();
            ResultSet rset3 = stmt3.executeQuery("select * from vote_detail"); 
            
            // 선택 후보의 상세 득표 수 (연령대별 득표 경향) 프린트
            while (rset3.next()) {
               if( rset3.getInt(3) > 0 ) {
                  out.println("<table id=do_vote cellspacing=0;>");
                  out.println("<tr>");
                  out.println("<td id=each_result_ageGroup align=left>"+rset3.getInt(1)*10+"대</td>");
                  out.println("<td id=each_result_bar align=left><img src=./redbar.png height=20px width="
                              +(rset3.getInt(2)*1.0)/(rset3.getInt(3)*1.0)*1000+"px>"
                              +"  "
                              +rset3.getInt(2)+"("
                              +Math.floor(((rset3.getInt(2)*1.0)/(rset3.getInt(3)*1.0)*100)*10+0.5)/10
                              +"%)</td>");
                  out.println("</tr>");
                  out.println("</table>");
               } else {
                  out.println("<table id=do_vote cellspacing=0;>");
                  out.println("<tr>");
                  out.println("<td id=each_result_ageGroup align=left>"+rset3.getInt(1)*10+"대</td>");
                  out.println("<td id=each_result_bar align=left><img src=./redbar.png height=20px width="
                              +0+"px>"
                              +"  "
                              +0+" ("
                              +0.0
                              +"%)</td>");
                  out.println("</tr>");
                  out.println("</table>");
               }
            }
            
            // 선택 후보 상세 데이터(연령별 득표율) 데이터 저장용 테이블 삭제;
            Statement stmt4 = conn.createStatement();
            stmt4.execute("drop table vote_detail;");
            
            rset1.close();
            rset3.close();
            stmt1.close();
            stmt2.close();
            stmt3.close();
            stmt4.close();
            conn.close();
         %>
         </form>
   </div>
 </body>
 </html>