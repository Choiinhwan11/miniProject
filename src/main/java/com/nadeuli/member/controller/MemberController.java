package com.nadeuli.member.controller;

import com.nadeuli.member.dto.MemberRequestDTO;
import com.nadeuli.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;


@Controller
@RequestMapping(value = "/member")
public class MemberController {
@Autowired
    private MemberService memberService;

    /**
     * 회원가입 form
     */
    @GetMapping("/memberJoinForm")
    public String memberJoinForm() {
        return "member/memberJoin";
    }


    /**
     * 아이디 유효성 검사
     */
    @ResponseBody
    @PostMapping("/checkId")
    public Map<String, String> checkId(@RequestBody Map<String, Object> map) {

        String mem_id = (String) map.get("mem_id");
        Map<String, String> response = new HashMap<>();
        System.out.println(mem_id);
        boolean checkIdResult = memberService.checkId(mem_id);
        System.out.println(checkIdResult);
        if (checkIdResult) {
            response.put("status", "exist");
        } else {
            response.put("status", "non_exist");
        }
        return response;
    }

    /**
     * 이메일 휴효성 검사
     */
    @ResponseBody
    @PostMapping("/emailCheck")
    public Map<String, String> chekcEmail(@RequestBody Map<String, Object> map) {

        String mem_Email = (String) map.get("mem_email");
        Map<String, String> EmailResult = new HashMap<>();
        boolean ChekcEmailResult = memberService.checkEmail(mem_Email);
        System.out.println("map = " + map);
        if (ChekcEmailResult) {
            EmailResult.put("status", "true");
        } else {
            EmailResult.put("status", "false");
        }
        return EmailResult;
    }
    /**
     * 이메일 유효성 검사
     * */
//    @PostMapping("/checkEmail")
//    public String checkEmail(Model model, @RequestParam("mem_Email") String mem_email) {
//        int checkEmailResult = memberService.checkEmail(mem_email);
//
//        // 이메일 중복 결과를 모델에 추가
//        if (checkEmailResult <= 3) {
//            model.addAttribute("emailCheckResult", 0); // 중복 이메일 없음
//        } else {
//            model.addAttribute("emailCheckResult", 1); // 중복 이메일 있음
//        }
//
//        // 이메일 중복 확인 결과를 보여줄 뷰 이름 반환
//        return "checkEmailResult"; // 해당 뷰 파일명으로 변경 필요
//    }

    /**
     * 회원가입
     */
    @ResponseBody
    @PostMapping("/memberJoin")
    public String memberJoin(@RequestBody MemberRequestDTO memberRequestDTO) {

        System.out.println("memberRequestDTO = " + memberRequestDTO);
        boolean memberJoinResult = memberService.memberJoin(memberRequestDTO);
        System.out.println("memberJoinResult = " + memberJoinResult);
        if (memberJoinResult) {
            return "가입성공";
        } else {
            return "가입실패";
        }
    }


    /*로그인 로직 */
    /*로그인 폼으로 가기*/
    @GetMapping("/loginForm")
    public String loginForm() {
        return "member/loginForm";
    }

    /**
     * 로그인 기능
     */

    @ResponseBody
    @PostMapping("/login")
    public Map<String, Object> login(@RequestBody MemberRequestDTO memberRequestDTO,
                                     HttpSession session) {
        System.out.println(memberRequestDTO + " member login");
        session.removeAttribute("MEM_ID");
        // 새 세션 생성
        //session.invalidate(); -> 이 경우에는 httpresponse  사용 해야 한다 .
        //HttpSession newSession =response.getSession(true);

        boolean loginResult = memberService.login(memberRequestDTO);
        System.out.println(memberRequestDTO + " member login");

        Map<String, Object> responseMap = new HashMap<>();
        responseMap.put("loginResult", loginResult);
        System.out.println("loginResult = " + loginResult);
        if (loginResult) {
            // 로그인 성공 시, 새로운 세션에 사용자 ID 저장
            session.setAttribute("MEM_ID", memberRequestDTO.getMEM_ID());
            responseMap.put("MEM_ID", memberRequestDTO.getMEM_ID());
        }
        // 로그인 실패 시, 세션에 사용자 ID를 저장하지 않음
        return responseMap;
    }
    /**
// * 로그아웃 세션 없애기
// * */
    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // 세션 제거
        }
        return "redirect:/index";
    }

/**
     * 아이디 찾기 로직
     */
    @GetMapping("/findId")
    public String findIdForm() {
        return "member/findId";
    }



    @PostMapping("/lostId")
    @ResponseBody
    public String lostId(@RequestBody MemberRequestDTO memberRequestDTO, Model model) {

        //이름 이메일을 갖고가서  아이디 찾고
        String lostId = memberService.findmemberid(memberRequestDTO);
        if (lostId != null){
            return "당신의 아이디는"+ lostId+"입니다.";
        } else {
            return "당신의 아이디는 없습니다.";
        }
        //찾은 아이디를 갖고와서 저장해주고 보여주기

    }










    /**
     * 비밀번호 찾기 로직
     */
    @GetMapping("/findPwd")
    public String findPwdForm() {
        return "member/findPwd";
    }
}





