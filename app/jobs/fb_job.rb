class FbJob < ApplicationJob
  queue_as :low_priority
  require 'openssl'
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  require 'uri'
  require 'net/http'
  require 'json'

  ## 학교별 URI 세팅 ########################
  @@id = ENV["FB_ID"]
  @@pw = ENV["FB_PW"]
  @@korea = "koreabamboo"
  @@yonsei = "yonseibamboo"
  @@sogang = "sogangbamboo"
  @@schools = [@@korea, @@yonsei, @@sogang]
  @@school = @@korea
  @@uri = "https://graph.facebook.com/v2.9/#{@@school}?&access_token=#{@@id}|#{@@pw}&fields=posts.limit(100){id,from,message,created_time,reactions.limit(0).summary(true),reactions.type(LIKE).limit(0).summary(true).as(like),reactions.type(LOVE).limit(0).summary(true).as(love),reactions.type(HAHA).limit(0).summary(true).as(haha),reactions.type(WOW).limit(0).summary(true).as(wow),reactions.type(SAD).limit(0).summary(true).as(sad),reactions.type(ANGRY).limit(0).summary(true).as(angry),comments.limit(2){id,from{name,picture},message,attachment,created_time,reactions.limit(0).summary(true),reactions.type(LIKE).limit(0).summary(true).as(like),reactions.type(LOVE).limit(0).summary(true).as(love),reactions.type(HAHA).limit(0).summary(true).as(haha),reactions.type(WOW).limit(0).summary(true).as(wow),reactions.type(SAD).limit(0).summary(true).as(sad),reactions.type(ANGRY).limit(0).summary(true).as(angry)}}"
  @@sIndex = 0


  def changeSchoolURI
    if @@sIndex == 0
      @@sIndex = 1
    elsif @@sIndex == 1
      @@sIndex = 2
    else
      @@sIndex = 0
    end

    @@school = @@schools[@@sIndex]
    @@uri = "https://graph.facebook.com/v2.9/#{@@school}?&access_token=#{@@id}|#{@@pw}&fields=posts.limit(100){id,from,message,created_time,reactions.limit(0).summary(true),reactions.type(LIKE).limit(0).summary(true).as(like),reactions.type(LOVE).limit(0).summary(true).as(love),reactions.type(HAHA).limit(0).summary(true).as(haha),reactions.type(WOW).limit(0).summary(true).as(wow),reactions.type(SAD).limit(0).summary(true).as(sad),reactions.type(ANGRY).limit(0).summary(true).as(angry),comments.limit(2){id,from,message,attachment,created_time,reactions.limit(0).summary(true),reactions.type(LIKE).limit(0).summary(true).as(like),reactions.type(LOVE).limit(0).summary(true).as(love),reactions.type(HAHA).limit(0).summary(true).as(haha),reactions.type(WOW).limit(0).summary(true).as(wow),reactions.type(SAD).limit(0).summary(true).as(sad),reactions.type(ANGRY).limit(0).summary(true).as(angry)}}"
    @@uri = URI.parse(@@uri)
  end
  ##########################################

  ## 액션잡 및 모델 객체 카운트 및 에러 객체 ##
  @@ct = 0
  @@md = 0
  @@err = []
  ##########################################

  ## 엔트리 포인트 ##
  def perform(*args)
    if args[0] == "initial"
      args[0] = @@uri
    end

    if args[2] == "reset"
      @@ct = 0
      @@md = 0
    end
    @@ct += 1
    puts
    puts ">>>>>>>>>>>>>>>>>> #{@@school} #{@@ct}번째 액션잡 시작 <<<<<<<<<<<<<<<<<<"

    res = Net::HTTP.get_response(URI.parse(args[0]))
    case res.code.to_i
    when 200
      puts "=>=>=>=>=>=>=>=> 데이터 수신 성공! =>=>=>=>=>=>=>=>"
      ## JSON 파싱(100개로 구성) ##
      json=JSON.parse(res.body)
      ## JSON 데이터 배열 순환 탐색 ##
      100.times do |i|
        # 주석 해제해주세요
        # puts "]]]] JSON 배열 탐색시작 :: #{i+1} 회차 [[[["
      ## 처음 시작 인 경우와 이후 반복 패턴인 경우 구분 ##
      ## posts 배열에서 post 추출
      ## post 변수 기준으로는 하위 구조 동일하므로 코드 공유 가능 ##
        if args[1] == "start"
          post = (json["posts"]["data"][i])
        elsif args[1] == "second"
          ## 두번째 반복패턴부터는 posts WRAPPER가 없음 ##
          post = (json["data"][i])
        end

        ## 무조건 100번을 돌도록 되어 있기에 데이터가 있는 경우에만 탐색 ##
        if post != nil
          ## 코멘트를 없다고 가정 ##
          c1 = nil
          c2 = nil
          ## 코멘트가 있는 경우 각각 c1, c2에 저장 ##
          if post.key?("comments")
            comments = post["comments"]["data"]
            ## 첫 번째 베댓 ##
            c1 = comments[0]
            ## 두 번째 베댓 ##
            c2 = comments[1]
          end

          ## 모델 생성 시작 ##
          # 주석 해제해주세요
          # puts "==>==>==>==> 모델 생성을 시작하겠습니다. ==>==>==>==>"
          ## 좋아요 개수로 필터링 : 해당 갯수가 넘는 경우에만 실제 생성 ##
          if post["reactions"]["summary"]["total_count"] >= 1000
          ## 포스트 본문 부분 ####
            ## 포스트 저장 여부 확인 ##
            if p=Post.find_by(p_id: post["id"])
              puts "==>==>~~> 모델 업데이트를 시작합니다. ~~>==>==>"
            else
              puts "==>==>~~> 모델을 새롭게 생성합니다. ~~>==>==>"
              p = Post.new
              p.p_id=post["id"]
            end

            p.p_writer=post["from"]["name"]
            p.p_message=post["message"] if post["message"] != nil
            p.p_time=DateTime.parse(post["created_time"])
            ## 포스트 리액션 ##
            p.p_reactions_count=post["reactions"]["summary"]["total_count"]
            p.p_likes_count=post["like"]["summary"]["total_count"]
            p.p_loves_count=post["love"]["summary"]["total_count"]
            p.p_hahas_count=post["haha"]["summary"]["total_count"]
            p.p_wows_count=post["wow"]["summary"]["total_count"]
            p.p_sads_count=post["sad"]["summary"]["total_count"]
            p.p_angrys_count=post["angry"]["summary"]["total_count"]
            ## 포스트 본문 끝 ####

            ## 포스트 댓글 시작 ####
            ## 경우의 수 3가지 :
            ## 1,2 다있는 경우 // 1만 있는 경우 // 1,2 다 없는 경우
            ## 댓글이 1개도 없는 경우 ##
            if c1 == nil && c2 == nil
              puts "==========> 댓글이 1개도 없습니다 <=========="
            elsif c1 != nil
            ## 댓글이 1개라도 있는 경우 실행됨(c1 초기화)
              p.c1_id=c1["id"]
              p.c1_name=c1["from"]["name"]

              p.c1_profile=c1["from"]["picture"]["data"]["url"]

              p.c1_message=c1["message"] if c1["message"] != nil
              ## >> 새로 추가한 부분. 첨부 사진(영상X)
              p.c1_attachment=c1["attachment"]["media"]["image"]["src"] if c1["attachment"] != nil
              p.c1_time=DateTime.parse(c1["created_time"])
              p.c1_reactions_count=c1["reactions"]["summary"]["total_count"]
              p.c1_likes_count=c1["like"]["summary"]["total_count"]
              p.c1_loves_count=c1["love"]["summary"]["total_count"]
              p.c1_hahas_count=c1["haha"]["summary"]["total_count"]
              p.c1_wows_count=c1["wow"]["summary"]["total_count"]
              p.c1_sads_count=c1["sad"]["summary"]["total_count"]
              p.c1_angrys_count=c1["angry"]["summary"]["total_count"]

              if c2 != nil
              ## 댓글이 2개 이상 있는 경우 실행됨(c2 초기화,1개인 경우 생략됨)
                p.c2_id=c2["id"]
                p.c2_name=c2["from"]["name"]

                p.c2_profile=c2["from"]["picture"]["data"]["url"]

                p.c2_message=c2["message"] if c2["message"] != nil
                ## >> 새로 추가한 부분. 첨부 사진(영상X)
                p.c2_attachment=c2["attachment"]["media"]["image"]["src"] if c2["attachment"] != nil
                p.c2_time=DateTime.parse(c2["created_time"])
                p.c2_reactions_count=c2["reactions"]["summary"]["total_count"]
                p.c2_likes_count=c2["like"]["summary"]["total_count"]
                p.c2_loves_count=c2["love"]["summary"]["total_count"]
                p.c2_hahas_count=c2["haha"]["summary"]["total_count"]
                p.c2_wows_count=c2["wow"]["summary"]["total_count"]
                p.c2_sads_count=c2["sad"]["summary"]["total_count"]
                p.c2_angrys_count=c2["angry"]["summary"]["total_count"]
              end
            end
            ## 포스트 댓글 끝 ####

            if p.save
              @@md +=1
              # 주석 해제해주세요
              # puts "++>++>++>모델이 성공적으로 저장되었습니다.<++<++<++"
              puts "~~~~~~>> 현재 누적 모델 개수 : #{@@md} 개 <<~~~~~~"
            else
              puts "!!!!!!!!!! 모델 저장에 실패하였습니다 !!!!!!!!!!"
              @@err << "저장에 실패한 포스트 ID :: #{post["id"]}"
            end
            # 주석 해제해주세요
            # puts "==>==>==>==> 모델 생성을 종료합니다. ==>==>==>==>"
          ## 여기까지가 좋아요 개수 충족시 실행되는 부분 ##
          else
            # 주석 해제해주세요
            # puts "<==<==<== 좋아요가 부족하여 모델 생성이 취소되었습니다. ==>==>==>"
          end
          ## 좋아요 필터링 종료 ##

        ## post == nil 인 경우의 로그 출력
        else
          puts ">>>> 포스트가 없습니다 || #{i+1} 회차"
        end
        # 주석 해제해주세요
        # puts "]]]] JSON 배열 탐색종료 :: #{i+1} 회차 [[[["
      end
      ## 여기까지 JSON 배열 탐색 종료 ##

      ## NEXT 페이지 존재 여부 확인 ##
      if args[1] == "start"
        @next = json["posts"]["paging"]["next"]
      elsif args[1] == "second"
        @next = json["paging"]["next"]
      end

      if @next
        puts "~>~> NEXT 페이지가 존재하므로 새로운 ACTION JOB을 ENQUEUE 합니다 <~<~"
        FbJob.perform_later "#{@next}", "second"
      else
        puts "!!!!!!!! NEXT 페이지가 없습니다. 크롤링을 종료합니다. !!!!!!!!"
        ## 다른 학교 크롤링 호출 ##
        puts
        @next = changeSchoolURI
        puts "%%%%%%%%%% #{@@school} 크롤링을 시작합니다 %%%%%%%%%%"
        FbJob.perform_later "#{@next}", "start", "reset"
        #########################
      end

    else
      ## 에러 핸드링. 상태코드가 200이 아닌 경우 실행 됨 ##
      puts "!!!!!!!!!! API 호출에 문제가 발생했습니다 !!!!!!!!!!"
      puts
      print ">> 응답 상태 코드 : "
      puts res.code
      print ">> 응답 메시지 : "
      puts res.message
      puts
      @@err << "#{args[0]} || #{res.code} || #{res.message}"
      puts ">>>>>>>>>>>>>>>>>>>>API 재요청을 시작합니다! >>>>"
      FbJob.perform_later args[0], args[1]
    end
    puts ">>>>>>>>>>>>>>>> #{@@school} #{@@ct}번째 액션잡 종료! <<<<<<<<<<<<<<<"
    puts "**** 모든 에러 출력 ****"
    puts @@err
    puts "**** 에러 출력 완료 ****"
  end
  ## 여기까지 액션잡 정의 끝 ##
end
