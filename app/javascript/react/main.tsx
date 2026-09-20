import React, { useEffect, useState } from "react";
import { createRoot } from "react-dom/client";
import {
  BandRecruitmentProps,
  CurrentUserProps,
  RecruitmentResponse,
} from "./types/BandRecruitment";
import { RecruitmentCard } from "./components/RecruitmentCard";

const RecruitmentList = () => {
  const [bandRecruitments, setBandRecruitments] = useState<
    BandRecruitmentProps[]
  >([]);
  const [currentUser, setCurrentUser] = useState<CurrentUserProps>({
    signedIn: false,
  });
  const source = new URLSearchParams(window.location.search).get("filter");

  useEffect(() => {
    const url =
      source === "my-band-recruitment"
        ? `/band_recruitments.json?filter=my-band-recruitment`
        : `/band_recruitments.json`;
    // fetchを使ってデータを取得する
    fetch(url) //URLにアクセス
      // HTTPリクエストからのレスポンスを受け取り、JSONに変換
      .then((response) => response.json())
      // JSONデータをsetBandRecruitmentsにセット
      .then((data: RecruitmentResponse) => {
        setCurrentUser(data.currentUser);
        setBandRecruitments(data.bandRecruitments);
      })
      // エラーがあった場合はエラーを出力
      .catch((error) => console.error("Fetch error:", error));
  }, [source]);

  return (
    <>
      {bandRecruitments.map((bandRecruitment) => (
        <RecruitmentCard
          // 一覧の中で、どのカードなのか識別できるようにする
          key={bandRecruitment.id}
          // bandRecruitmentオブジェクトを渡す
          bandRecruitment={bandRecruitment}
          currentUser={currentUser}
        />
      ))}
      <div className="display-create-btn">
        <a className="btn-add" href="/band_recruitments/new"></a>
      </div>
    </>
  );
};

const element = document.getElementById("band-recruitment-list");

if (element && !element.dataset.reactMounted) {
  element.dataset.reactMounted = "true";

  const root = createRoot(element);
  root.render(<RecruitmentList />);
}
