# :iphone: [Project/App Name]
[Logo/Cover Image]

[App statement]

## :fireworks: Screenshots

Attach photos if you are available

## :framed_picture: Demo (optional)

Attach videos if you are available


## :pushpin: Features

- Feature 1
- Feature 2
- Feature 3


## :sparkles: Skills & Tech Stack

ex) <img src="https://img.shields.io/badge/Swift-FA7343?style=flat&logo=Swift&logoColor=white"/>, SwiftUI

위와 같이 배지를 사용하여 더 풍성한 Readme를 만들 수 있습니다.
[참조](https://shields.io/)


## :people_hugging: Authors

@username, @username, @username, @username, @username, @username



# ⛙ Git Convention

## 이슈
- 템플릿 사용
```swift
## 🍏 About
* 

## 🍀 Branch Name
feat/#?-

## 🌱 To do
- [ ]
```

1. 이슈를 등록할 때는 맨 앞에 이슈 종류 쓰기 (예: `[feat] 로그인 구현`)
2. 하나의 이슈가 크면 내부에 `task list` 만들어서 세분화하기
3. 이슈에 맞는 `label` 달기
4. 이슈를 등록하면 번호가 할당됨

## 브랜치
1. 브랜치명 = `분류` /`#이슈 번호`

```
chore/#3
feat/#3
```

2. `하나의 브랜치`에서는 `하나의 이슈`만 작업함
3.  이슈가 커서 task list로 세분화했으면 그 브랜치를 task 브랜치로 나눈 후 작업하기
(예: `task/#23-1`, `task/#23-2`)
4. `task 브랜치`에는 `1개의 커밋`만 하는 게 최종 목표

## 커밋
1.  커밋 메시지 앞에 `[#이슈번호]` 넣기
2.  task 브랜치인 경우 `[#이슈번호-task숫자]` 이런 식으로 커밋 메시지 앞에 추가
예) `[#23-1]`, `[#17-3]`
3. 이렇게 하면 그 커밋에 관련된 이슈를 확인할 수 있음

## PR
- 템플릿 사용
   - `Assignee`에 본인 등록
   - `Reviewer`로 팀원 등록

```
## ✅ 작업한 내용
 - 

## ⭐️ PR Point
 <!-- 피드백 받고 싶은 부분, 공유하고 싶은 부분, 작업 과정, 이유 -->
 -

## 📸 스크린샷


## 💡 관련 이슈
- Resolved: #
```

1. `PR(Pull Request)` 올리기
1. 이슈가 커서 `task 브랜치`로 쪼개서 작업을 한 경우에는 `기존 이슈 브랜치 방향`으로 PR 올리기
1. task 브랜치가 기존 이슈 브랜치로 모두 다 머지 되면 기존 이슈 브랜치는 develop 브랜치 방향으로 PR 올리기
1. Draft PR 올려야 된다면 PR명 앞에 `[Draft PR-#브랜치번호]` 붙여서 올리기
1. 코드 리뷰를 받고 피드백을 토대로 코드를 수정한 후 확인받기
1. **마지막으로! ⭐️Rebase and Merge⭐️**
