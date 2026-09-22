## はじめに
Gather Bandは、バンドの募集者と応募者が相性を確認してからマッチングできるバンドマッチングアプリです。<br/>
応募者は募集内容との相性と募集者のプロフィールを確認してから応募ができ、募集者は応募者のプロフィールと人物相性を確認してから承認/見送りを判断できます。<br/>
相性や活動の方向性を確認してからバンドを組めるサービスが欲しいと考え、開発しました。

※本アプリはポートフォリオ作品です。本アプリの利用によって生じたトラブル等については、一切の責任を負いかねます。<br/>
※個人情報保護のため、実際に利用しているメールアドレスの登録はお控えください。<br/>
※アプリの機能をお試しいただく際は、ログイン→「ゲストログイン」をご利用ください。ゲストアカウントで各種機能をお試しいただけます。<br/>

アプリURL：https://band-app-production-97ba5b7758b6.herokuapp.com/
<br/><br/>

## 開発背景
趣味でバンド活動をする中で、バンド結成前に相手の人物像や活動の方向性が分からないため、バンドが結成されても、活動方針や相性の違いから関係性を継続することが難しいケースがあると感じていました。<br/>
そこで、募集内容と応募者の相性を確認できる「募集相性」と、募集者と応募者の人物面での相性を確認できる「人物相性」を設け、バンド結成前に相性や活動の方向性を確認することで、結成後のミスマッチを減らしたいと考え、本アプリを開発しました。<br/>
また、CRUD実装からUI/UX設計・テスト・運用まで、Web開発の一連のプロセスを経験することも目的としています。
<br/><br/>

## デモ動画

https://github.com/user-attachments/assets/28ea085c-35f5-49d0-bde9-be232ff5fef6

<br/>

## 主な使用技術
<h3>バックエンド</h3>

![Ruby](https://img.shields.io/badge/Ruby-CC342D?style=flat&logo=ruby&logoColor=white)
![Rails](https://img.shields.io/badge/Rails-D30001?style=flat&logo=rubyonrails&logoColor=white)
![Devise](https://img.shields.io/badge/Devise-D30001?style=flat)

<h3>フロントエンド</h3>

![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=flat&logo=html5&logoColor=white)
![SCSS](https://img.shields.io/badge/SCSS-CC6699?style=flat&logo=sass&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=flat&logo=javascript&logoColor=black)
![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?style=flat&logo=typescript&logoColor=white)
![React](https://img.shields.io/badge/React-61DAFB?style=flat&logo=react&logoColor=black)
![Haml](https://img.shields.io/badge/Haml-000000?style=flat)

<h3>インフラ・データベース</h3>

![Heroku](https://img.shields.io/badge/Heroku-430098?style=flat&logo=heroku&logoColor=white)
![AWS S3](https://img.shields.io/badge/AWS%20S3-232F3E?style=flat&logo=amazons3&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=flat&logo=postgresql&logoColor=white)

<h3>ツール</h3>

![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat&logo=github&logoColor=white)
![VS Code](https://img.shields.io/badge/VS%20Code-007ACC?style=flat&logo=visualstudiocode&logoColor=white)
![RSpec](https://img.shields.io/badge/RSpec-D30001?style=flat)
![Prettier](https://img.shields.io/badge/Prettier-F7B93E?style=flat&logo=prettier&logoColor=black)
<br/><br/>

## 機能一覧
| 機能 |　詳細 |
|---|---|
| ユーザー登録・ログイン | ユーザーの登録・ログインができます。 |
| プロフィール登録・編集 | プロフィールの登録・編集ができます。 |
| 全体募集一覧 | 全体の募集を閲覧できます。<br/>自分のパート・活動地域と一致した募集を自動的に絞り込み表示します。<br/>募集相性を確認できます。<br/>ログインユーザーは本画面から募集を作成できます。 |
| 自分の募集一覧 | 自分が作成した募集の一覧が表示されます。<br/>参加メンバーの確認ができます。<br/>参加メンバーがいない募集のみ、編集・削除できます。 |
| 参加希望 [自分から] | 自分が参加希望した募集の一覧とマッチング状況を確認できます。 |
| 参加希望 [相手から] | 相手から参加希望のあった自分の募集一覧を確認できます。<br/>募集詳細画面で、応募者のプロフィールと人物相性を確認し、承認/見送りを選択できます。 |
| 募集詳細 | 募集内容の詳細と募集者のプロフィールを閲覧できます。<br/>ログインユーザーは参加希望を送信できます。 |
| 相性表示 | 応募者は募集内容との募集相性を確認できます。 <br/>募集者は応募者との人物相性を確認できます。|
| SNSリンク表示 | マッチングが成立した応募者と募集者間で、プロフィールに登録したSNSリンクを閲覧できます。|

※未ログインユーザーは全体募集一覧と募集詳細のみ閲覧できます。その他の機能を利用するにはログインが必要です。<br/>
※人物相性は、好きなバンドタグ・性格タグの一致率をもとに算出しています。<br/>
※募集相性は、活動ジャンル・楽曲タイプ・活動志向の一致率をもとに算出しています。
<br/><br/>

## ER図
![ER図](docs/images/ER-diagram.png)
<br/><br/>

## 意識した点
- バンド結成前に相性や活動の方向性を確認し、応募・承認判断をスムーズに行えるように、募集相性・人物相性ロジックをもとに相性結果を算出し、表示する機能を実装しました。<br/>
- ユーザーが目的に応じて管理しやすいよう、全体募集一覧、自分の募集一覧、参加希望 [自分から]、参加希望 [相手から]のタブごとに操作可能な範囲を分けました。（機能一覧参照）<br/>
- RESTfulな設計とコードの可読性・保守性を意識し、リソースに沿ったルーティング設計や、重複処理の整理・リファクタリングを行いました。
<br/><br/>

## 今後実装予定の機能
| 機能 |　詳細 |
|---|---|
| 承認コメント | 承認時に応募者へのコメントを送れるようにします。 |
| 募集一覧のソート | 募集期限が短い順/新着順などで並び替えられるようにします。 |
| 募集の絞り込み | 条件を指定して募集を絞り込めるようにします。 |
| スカウト | ユーザーのプロフィールを確認し、バンドに加入してほしいユーザーへスカウトを送れるようにします。 |
<br/>

## 終わりに
Webアプリ開発学習のアウトプットして、公開させていただきました。<br/>
最後までご覧いただき、ありがとうございました。

