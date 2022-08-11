<%@ page contentType="text/html; charset=UTF-8" %>
<!-- JSP의 인코딩 방식 선언 ==> UTF-8 ==> 한글 깨지지 않도록 지정 -->
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.*" %>
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
	  
      .menu_vote{
         background-color: yellow;
      }

      #do_vote {
         width: 95%;
         padding: 2%;
         border: 1px solid black;
         margin-left: auto;
         margin-right: auto;
         font-size: 20px;
      }
      
      #_number {
         font-size: 25px;
      }
      
      #_ageGroup {
         font-size: 25px;
      }
      
      #button{
         border: 3px solid darkgreen;
         background-color: lightgreen;
         font-size: 20px;
         opacity: 1;
         
      }
      
      #result_table {
         width: 100%;
      }
      
      #result_message{
         font-size: 40px;
         text-align: center;
         background-color: lightgreen;
      }
   </style>
   
   <div id=container>
   <br>
      <div id="inner">
         <div onclick="location.href='./A_01.jsp'" id="menu" class="menu_enroll">후보등록</div>
         <div onclick="location.href='./B_01.jsp'" id="menu" class="menu_vote">투표</div>
         <div onclick="location.href='./C_01.jsp'" id="menu" class="menu_result">개표결과</div>
         <br>
         <br>
         <form method="post" action="./B_02.jsp">
         <table id="do_vote">
            <tr>
            <%
            // 데이터베이스 접근
            ArrayList <Integer> get_number = new ArrayList<Integer>();
            ArrayList <String> get_name = new ArrayList<String>();
            
            Class.forName("com.mysql.cj.jdbc.Driver");      //JDBC 드라이버 로드
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo08","root","root");
                                                //127.0.0.1 = localhost
                                          
            // 테이블에서 데이터 읽어오기
            Statement stmt1 = conn.createStatement();      // Statement(sql 쿼리 전달) 변수에 database연결-명령어 저장;
            ResultSet rset1 = stmt1.executeQuery("select * from hubo_table;");   
            
            while(rset1.next()) {
               get_number.add(rset1.getInt(1));
               get_name.add(rset1.getString(2));
            }
            %>
                  
               <td align="left">
                  <select id="_number" name="_number">
                     <optgroup label="후보" required>
                        <%
                        for (int i = 0; i < get_number.size(); i++) {
                           out.println("<option value="+get_number.get(i)+">"+get_number.get(i)+"번 "+get_name.get(i)+"</option>");
                        }
                        %>
                     </optgroup>
                  </select>
               </td>
               
               <td align="left">
                  <select id="_ageGroup" name="_ageGroup" required>
                     <optgroup label="투표자 연령대">
                        <option value="1">10대</option>
                        <option value="2">20대</option>
                        <option value="3">30대</option>
                        <option value="4">40대</option>
                        <option value="5">50대</option>
                        <option value="6">60대</option>
                        <option value="7">70대</option>
                        <option value="8">80대</option>
                        <option value="9">90대</option>
                     </optgroup>
                  </select>
               </td>
			   <%
               if(get_name.size() < 1){
				} else {
				out.println("<td align=right><input type=submit onclick=location.href='./B_02.jsp' id=button value=투표하기 required /></td>");
				}
				%>
            </tr>
         </table>
         </form>
         <br>
         <table id="result_table">
            <tr>
               <td id="result_message"></td>
            </tr>
         </table>
         <br>
      </div>
      <br><br><br>
   </div>
 </body>
 </html>