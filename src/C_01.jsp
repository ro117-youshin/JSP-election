<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*" %>
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
         font-size: 20px;
      }
      
      #do_vote {
         width: 95%;
         margin-left: auto;
         margin-right: auto;
         font-size: 20px;
         border: 1px solid black;
      }
      
      #button {
         border: 0;   
         background-color: transparent;
         text-decoration: underline;
         font-size: 20px;
      }
      #each_result_name{
         text-decoration: underline;
         font-size: 25px;
         width:15%;
      }
      #each_result_bar{
         border-left: 1px solid black;
         font-size: 25px;
         width:90%;
      }
      
      #small_title{
         width: 100%;
         text-align: left;
         font-size: 30px;
         margin: 1%;
      }
      
      a{
         text-decoration-line: underline;
      }

   </style>
   
   <div id=container>
   <br>
         <div onclick="location.href='./A_01.jsp'" id="menu" class="menu_enroll">후보등록</div>
         <div onclick="location.href='./B_01.jsp'" id="menu" class="menu_vote">투표</div>
         <div onclick="location.href='./C_01.jsp'" id="menu" class="menu_result">개표결과</div>
         <br>
         <br>
         <div id="small_title">후보별 득표율</div>
         <%
            // 데이터베이스 연결
            Class.forName("com.mysql.cj.jdbc.Driver");      //JDBC 드라이버 로드
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo08","root","root");
                                                //127.0.0.1 = localhost
                                          
            // 테이블에서 데이터 읽어오기
            Statement stmt1 = conn.createStatement();      // Statement(sql 쿼리 전달) 변수에 database연결-명령어 저장;
            ResultSet rset1 = stmt1.executeQuery("select number, name, (select count(*) from Tupyo_table as b where b.number = a.number), (select count(*) from Tupyo_table)"+
												"from hubo_table as a group by a.number order by a.number asc;");   
            
            while(rset1.next()) {
               int result_number = rset1.getInt(1);
               String result_name = rset1.getString(2);
               int result_voted = rset1.getInt(3);
               int result_all = rset1.getInt(4);
               
               if (result_voted > 0) {
                  out.println("<table id=do_vote cellspacing=0;>");
                  out.println("<tr>");      
                  out.println("<td align=left><a href='./C_02.jsp?get_number="+result_number+"&get_name="+result_name+"' name=_selectCandidate id=button>"
                              +result_number+"번 "+result_name+"</a></td>");
                  out.println("<td id=each_result_bar align=left><img src=./redbar.png height=20px width="
                              +(result_voted*1.0)/(result_all*1.0)*1000+"px>"
							  +"  "
                              +result_voted+" ("
                              +Math.floor((result_voted*1.0/result_all*1.0*100)*10+0.5)/10
                              +"%)</td>");
                  out.println("</tr>");
                  out.println("</table>");
               } else {
                  out.println("<table id=do_vote cellspacing=0;>");
                  out.println("<tr>");      
                  out.println("<td align=left><a href='./C_02.jsp?get_number="+result_number+"&get_name="+result_name+"' name=_selectCandidate id=button>"
                              +result_number+"번 "+result_name+"</a></td>");
                  out.println("<td id=each_result_bar align=left><img src=./redbar.png height=20px width="
                              +0+"px>"
                              +"  "
                              +result_voted+" ("
                              +0.0
                              +"%)</td>");
                  out.println("</tr>");
                  out.println("</table>");
               }
            }
            
            rset1.close();
            stmt1.close();
            conn.close();
         %>
         <br>
         <br>
      <br><br><br><br>
   </div>
 </body>
 </html>