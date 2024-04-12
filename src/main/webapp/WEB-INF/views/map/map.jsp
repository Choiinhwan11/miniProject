<%@ page isELIgnored="false" language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"  %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <script src="http://code.jQuery.com/jquery-3.7.1.min.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <link rel="stylesheet" type="text/css" href="/frame/css/frame.css">
    <link rel="stylesheet" type="text/css" href="/map/css/map.css">
</head>
<body>
<header>
    <jsp:include page="../frame/header.jsp"/>
</header>

<div id="frameContent">
    <div id="frameNav">
        <jsp:include page="../frame/nav.jsp"/>
    </div>
    <div id="main_map">
        <div class="leftmain">
            <div class="clickedsubjectsub">
                <h3>지역</h3>
            </div>

            <div class="clickedsubject">
                <h3 id="clickedsubject">
                    <p>해시태그를</p>
                    <p>클릭해보세요!</p>
                </h3>
            </div>
            <!-- 호버된 도/시 or 시/군/구 -->

            <div class="clickedcontentsub">
                <h3>지역 설명</h3>
            </div>

            <div class="clickedcontent">
                <h3 id="clickedcontent">
                    <p>지역에 대한</p>
                    <p>설명이</p>
                    <p>나옵니다</p>
                </h3>
            </div>
            <!-- 호버된 주제에 대한 설명 -->
        </div>
        <!-- leftmain -->

        <div class="middlemain">
            <div class="clickthemap">
                <h1>지도를 클릭해보세요!</h1>
            </div>
            <!-- 지도를 클릭해보세요! 문구 -->

            <div class="mapmain">
                <iframe
                        id="mapframe"
                        src="./korea"
                        style="border: 0; width: 100%; height: 100%"
                >
                </iframe>
            </div>
            <!-- 지도 사진 -->
        </div>
        <!-- middlemain -->

        <div class="rightmain">
            <div class="reset1">
                <button id="resetBtn1">시/도 선택</button>
            </div>
            <div class="locationsub">
                <h3>지역</h3>
            </div>
            <div class="location">
                <button id="11" class="seoul">#서울</button>
                <button id="41" class="gyeonggi">#경기</button>
                <button id="28" class="incheon">#인천</button>
                <button id="51" class="gangwon">#강원</button>
                <button id="43" class="chungbuk">#충북</button>
                <button id="44" class="chungnam">#충남</button>
                <button id="36" class="sejong">#세종</button>
                <button id="30" class="daejeon">#대전</button>
                <button id="26" class="busan">#부산</button>
                <button id="29" class="gwangju">#광주</button>
                <button id="47" class="gyeongbuk">#경북</button>
                <button id="48" class="gyeongnam">#경남</button>
                <button id="52" class="jeonbuk">#전북</button>
                <button id="46" class="jeonnam">#전남</button>
                <button id="27" class="daegu">#대구</button>
                <button id="31" class="ulsan">#울산</button>
                <button id="50" class="jeju">#제주</button>
            </div>
            <!-- 지역 -->

            <div class="reset2">
                <button id="resetBtn2">시/군/구 선택</button>
            </div>
            <div class="themesub">
                <h3>테마</h3>
            </div>
            <div class="theme">
                <button id="12">#관광</button>
                <button id="14">#문화</button>
                <button id="15">#행사</button>
                <button id="32">#숙박</button>
                <button id="38">#쇼핑</button>
                <button id="39">#음식</button>
                <button id="28">#레포츠</button>
            </div>
            <!-- 테마 -->
        </div>
        <!-- rightmain -->
    </div>
</div>
<div id="upDownBtn">
    <a href="#">
        <button id="upBtn">위로</button>
    </a>
    <a href="#bottom">
        <button id="downBtn">아래</button>
    </a>
</div>
<footer>
    <jsp:include page="../frame/footer.jsp"></jsp:include>
</footer>
<div id="bottom"></div>

</body>
<script src="/frame/js/frame.js"></script>
<%--<script src="../js/mypage.js"></script>--%>
<script>
    window.addEventListener("message", function(event) {
        // 메시지 수신 및 검증
        // if (event.origin !== "http://예상되는출처") { // 보안을 위해 출처 검증
        //     return; // 출처가 예상과 다르면 처리하지 않음
        // }

        // 메시지에서 정보 추출
        var data = event.data;
        var clickedSubject = data.clickedSubject;
        var clickedContent = data.clickedContent;
        var clickedRegion = data.clickedRegion;
        var iframe = document.getElementById('mapframe');
        if (data.newSrc) {
            iframe.src = data.newSrc;
        }

        // 정보를 웹 페이지에 표시
        document.getElementById("clickedsubject").innerHTML = clickedSubject;
        document.getElementById("clickedcontent").innerHTML = clickedContent;

        // 클릭된 지역의 버튼에 'active' 클래스 추가
        var buttons = document.querySelectorAll(".location button");
        for (var i = 0; i < buttons.length; i++) {
            if (buttons[i].classList.contains(data.clickedRegion)) {
                buttons[i].classList.add("active");
            } else {
                buttons[i].classList.remove("active");
            }
        }
    });
    document.addEventListener("DOMContentLoaded", function () {

        const jsonUrl = "/resources/map/json/korea.json";

        fetch(jsonUrl)
            .then((response) => {
                if (response.ok) {
                    return response.json();
                }
                throw new Error("데이터를 불러오는데 실패했습니다.");
            })
            .then((regionsData) => {
                document.querySelectorAll(".location button").forEach((button) => {
                    button.addEventListener("click", function () {
                        const regionData = regionsData.features.find(
                            (feature) => feature.properties.CTPRVN_CD === button.id
                        );

                        if (regionData) {
                            document.getElementById("clickedsubject").textContent =
                                regionData.properties.CTP_KOR_NM;
                            document.getElementById("clickedcontent").textContent =
                                regionData.properties.CTP_Description;

                            // 모든 버튼의 'active' 클래스를 제거
                            document.querySelectorAll(".location button").forEach((btn) =>
                                btn.classList.remove("active")
                            );

                            // 클릭한 버튼에만 'active' 클래스 추가
                            button.classList.add("active");


                            // 버튼의 id를 이용해 해당 지역의 .jsp 파일 경로를 생성하고 iframe의 src 속성 변경
                            let regionPage = './korea'; // 기본값
                            let regionName = regionData.properties.CTP_ENG_NM.toLowerCase();
                            regionPage = './sido/' + regionName;
                            fetch("./sido/" + regionName + ".json")
                                .then(response => response.json())
                                .then(regionData => {
                                    const locationButton = document.querySelector(".rightmain .location button");
                                    if (locationButton && regionData.properties && regionData.properties.SIG_KOR_NM) {
                                        locationButton.textContent = regionData.properties.SIG_KOR_NM;
                                        locationButton.id = regionData.properties.SIG_KOR_NM;
                                    }
                                })
                                .catch(error => console.error(regionName + " 데이터 로드 실패:", error));
                            document.getElementById("mapframe").src = regionPage;
                        }
                    });
                });
            })
            .catch((error) => {
                console.error("Error:", error);
            });
    });
    document.getElementById("resetBtn1").addEventListener("click", function () {
        // iframe의 src를 기본 지도 페이지로 변경
        document.getElementById("mapframe").src = "./korea";

        // 선택된 지역 버튼의 'active' 클래스 제거
        document.querySelectorAll(".location button").forEach((button) =>
            button.classList.remove("active")
        );
        // 모든 테마 버튼의 'active' 클래스 제거
        document.querySelectorAll(".theme button").forEach((button) =>
            button.classList.remove("active")
        );

        // 테마 초기화
        document.getElementById("clickedsubject").textContent = "해시태그를 클릭해보세요!";
        document.getElementById("clickedcontent").textContent = "지역에 대한 설명이 나옵니다";
    });

    document.getElementById("resetBtn2").addEventListener("click", function () {
        // 모든 테마 버튼의 'active' 클래스 제거
        document.querySelectorAll(".theme button").forEach((button) =>
            button.classList.remove("active")
        );

        var iframe = document.getElementById("mapframe");
        if (iframe.src === "http://223.130.130.226:8090/map/korea") {
            alert("먼저 시/도를 선택해주세요.");
        } else {
            // 현재 iframe 새로고침
            iframe.src = iframe.src;
        }
    });

    document.addEventListener('DOMContentLoaded', function() {
        var buttons = document.querySelectorAll('.theme button');
        buttons.forEach(function(button) {
            button.addEventListener('click', function() {
                // 모든 버튼에서 active 클래스 제거
                buttons.forEach(btn => btn.classList.remove('active'));
                // 현재 클릭된 버튼에 active 클래스 추가
                this.classList.add('active');

                var contentTypeId = this.id; // 클릭된 버튼의 ID 값

                // iframe 내부의 문서에 접근하여 함수 실행
                var iframeDocument = document.getElementById('mapframe').contentWindow;
                iframeDocument.postMessage(contentTypeId, '*'); // '*'는 모든 출처를 의미합니다. 실제 배포시에는 보안을 위해 출처를 지정해야 합니다.
            });
        });
    });

</script>
</html>
