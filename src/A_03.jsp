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
      
      .menu_enroll{
         background-color: yellow;
      }

      form{
         display: inline; <!-- remove blank between form & form-->
      }
      
      input {
         font-size: 25px;
      }
      
      #candidates {
         width: 95%;
         padding: 1%;
         border: 1px solid black;
         margin-left: auto;
         margin-right: auto;
         font-size: 25px;
         cellspacing: 0;
      }
      .can_number {
         width: 35%;
      }
      
      .can_number_in {
         border:0;
         font-size: 25px;
      }
      
      .can_name {
         width: 55%;
      }
      
      .button{
         border: 3px solid darkgreen;
         background-color: lightgreen;
         font-size: 20px;
         opacity: 1;
         box-shadow: 2px 2px 4px 2px #dadce0;
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
   <script>
       function characterCheck(obj){
         var reg = /[\{\}\[\]\/?.,;:|\-_+<>@\#$%&\'\"\\\(\=`~!^*123456789\s]/gi;
         if (reg.test(obj.value)){
            alert("특수 문자나 숫자, 띄어쓰기는 입력하실 수 없습니다.");
            obj.value = obj.value.substring(0, 0);
         }
      }
      
      window.onload = function() {
         document.getElementById('formid').addEventListener('submit', function(e){
            if(document.getElementById('numid').value == ''){
               e.preventDefault()//기호 미입력을 방지
               alert('기호를 입력하세요')
            } else if(document.getElementById('nameid').value == ''){
               e.preventDefault()//이름 미입력을 방지
               alert('이름을 입력하세요')
            }
         });
      }   
   </script>
   
   <div id=container>
   <br>
      <div id="inner">
         <div onclick="location.href='./A_01.jsp'" id="menu" class="menu_enroll">후보등록</div>
         <div onclick="location.href='./B_01.jsp'" id="menu" class="menu_vote">투표</div>
         <div onclick="location.href='./C_01.jsp'" id="menu" class="menu_result">개표결과</div>
         <br>
         <br>
         <!-- 기존 후보 조회 및 삭제란-->
         <form method="post" action="./A_02.jsp">
         <%
            // 삭제할 후보 번호 받아오기
            int drop_number = Integer.parseInt(request.getParameter("_Dropnumber"));
            
            // 데이터베이스 연결
            Class.forName("com.mysql.cj.jdbc.Driver");      //JDBC 드라이버 로드
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo08","root","root");
                                                //127.0.0.1 = localhost
                                                
            // 후보 삭제
            Statement stmt0 = conn.createStatement();
            stmt0.execute("delete from hubo_table where number="+drop_number+";");   
            
            // 테이블에 저장된 데이터 개수 세기 : sql 쿼리 실행하여 나온 결과(ResultSet) 저장; ==> 전체 DataSet 개수 세기;
            Statement stmt1 = conn.createStatement();      // Statement(sql 쿼리 전달) 변수에 database연결-명령어 저장;
            ResultSet rset1 = stmt1.executeQuery("select count(*) from hubo_table;");   
            
            // 데이터 읽기
            Statement stmt2 = conn.createStatement();      // Statement(sql 쿼리 전달) 변수에 database연결-명령어 저장;
            ResultSet rset2 = stmt2.executeQuery("select * from hubo_table order by number asc;");   
   
            while (rset1.next()) {
               if (rset1.getInt(1) > 0) {
                  while(rset2.next()) {
                     out.println("<form method=post action='./A_03.jsp'>");
                     out.println("<table id=candidates>");
                     out.println("<tr>");
                     out.println("<td align=left class=can_number>기호번호 : <input type=number readonly class=can_number_in name=_Dropnumber value="+rset2.getInt(1)+"></td>");
                     out.println("<td align=left name=_Dropname class=can_name onkeyup=characterCheck(this) onkeydown=characterCheck(this)>후보명: "+rset2.getString(2)+"</td>");
                     out.println("<td align=right><input type=submit onclick=location.href='./A_03.jsp' formaction='./A_03.jsp' class=button value=삭제></td>");
                     out.println("</tr>");
                     out.println("</table>");
                     out.println("</form>");
                  }
               }
            }
            
			// 추가할 기호 자동 부여
            // 데이터 읽기
            Statement stmt3 = conn.createStatement();      // Statement(sql 쿼리 전달) 변수에 database연결-명령어 저장;
            ResultSet rset3 = stmt3.executeQuery("select number from hubo_table order by number asc;");   
            
            int id_number = 0;         // 최종 부여할 기호
            int number_min = 1;        // 기호 최솟값
            while (rset3.next()) { 
               if (rset3.getInt(1) == number_min) {
                  number_min = number_min + 1;
               } 
            }
            id_number = number_min; 
			
            // 데이터베이트 연결 해제
            rset1.close();
            rset2.close();
			rset3.close();
            stmt0.close();
            stmt1.close();
            stmt2.close();
			stmt3.close();
            conn.close();
            
         // 후보 추가란
            out.println("<form id=formid method=post action='./A_02.jsp'>");
            out.println("<table id=candidates>");
            out.println("<tr>");
            out.println("<td align=left class=can_number>기호번호: <input type=number name=_Addnumber min=1 id=numid readonly value="+id_number+"></td>");
            out.println("<td align=left class=can_name>후보명: <input type=text name=_Addname maxlength=20 id=nameid onkeyup=characterCheck(this) onkeydowncharacterCheck(this)></td>");
            out.println("<td align=right><input type=submit class=button value=추가></td>");
            out.println("</tr>");
            out.println("</table>");
            out.println("</form>");
         %>
         </form>
         <br>
         <table id="result_table">
            <tr>
               <td id="result_message">후보 삭제 결과 : 후보 삭제가 완료되었습니다.</td>
            </tr>
         </table>
         <br>
      </div>
      <br><br><br>
   </div>
 </body>
 </html>