import React from "react";
import { RecruitmentCardProps } from "../types/BandRecruitment";

export const RecruitmentCard = ({
  currentUser,
  bandRecruitment,
}: RecruitmentCardProps) => {
  const source = new URLSearchParams(window.location.search).get("filter");
  const recruitmentCardUrl = source
    ? `/band_recruitments/${bandRecruitment.id}?source=${source}`
    : `/band_recruitments/${bandRecruitment.id}`;

  return (
    <div className="recruitment-card">
      <a href={recruitmentCardUrl} className="recruitment-card-link">
        <div className="recruitment-card-top">
          <div className="recruitment-card-top-left">
            <div className={`card-status ${bandRecruitment.status}`}>
              {bandRecruitment.statusLabel}
            </div>
            <div className="card-deadline">
              期限：{bandRecruitment.deadline}
            </div>
          </div>
          <div className="recruitment-card-top-right">
            {currentUser.signedIn && bandRecruitment.isOwner ? (
              source === "my-band-recruitment" ? (
                bandRecruitment.hasApprovedApplications ? (
                  <div className="display-member-status">
                    参加メンバー
                    <span> {bandRecruitment.approvedApplicationsCount}名</span>
                  </div>
                ) : (
                  <div className="display-member-status">
                    参加メンバー<span className="none"> なし</span>
                  </div>
                )
              ) : (
                <div className="card-recruitment-compatibility">自分の募集</div>
              )
            ) : currentUser.signedIn && !bandRecruitment.isOwner ? (
              <div className="card-recruitment-compatibility">
                募集相性:
                <span> {bandRecruitment.recruitmentCompatibility}%</span>
              </div>
            ) : null}
          </div>
        </div>
        <div className="recruitment-card-middle">
          <div className="card-team">
            <div className="card-team-title">チーム名</div>
            <div className="card-team-name">
              {bandRecruitment.teamName ? bandRecruitment.teamName : "未設定"}
            </div>
          </div>
          <div className="card-title">{bandRecruitment.title}</div>
        </div>
        <div className="recruitment-card-bottom">
          <div className="card-content">
            <div className="card-content-title">募集パート：</div>
            <ul className="card-content-list">
              {bandRecruitment.recruitmentParts.map((rp) =>
                rp.full ? (
                  <li className="card-content-item" key={rp.id}>
                    <span className="display-group-content part_full">
                      {rp.part}
                    </span>
                    <span className="card-content-count-lg part_full">
                      満員
                    </span>
                  </li>
                ) : (
                  <li className="card-content-item" key={rp.id}>
                    <span className="card-content-text">{rp.part}</span>
                    <span className="card-content-count">×{rp.maxCount}</span>
                  </li>
                ),
              )}
            </ul>
          </div>

          <div className="card-content">
            <div className="card-content-title">活動地域：</div>
            {bandRecruitment.activityAreas.length > 0 ? (
              <ul className="card-content-list">
                {bandRecruitment.activityAreas.map((activityArea) => (
                  <li className="card-content-text" key={activityArea.id}>
                    {activityArea.name}
                  </li>
                ))}
              </ul>
            ) : (
              <div className="card-content-text">未設定</div>
            )}
          </div>
          <div className="card-content">
            <div className="card-content-title">活動ジャンル：</div>
            {bandRecruitment.activityGenres.length > 0 ? (
              <ul className="card-content-list">
                {bandRecruitment.activityGenres.map((activityGenre) => (
                  <li className="card-content-text" key={activityGenre.id}>
                    {activityGenre.name}
                  </li>
                ))}
              </ul>
            ) : (
              <div className="card-content-text">未設定</div>
            )}
          </div>
          <div className="card-content">
            <div className="card-content-title">活動志向：</div>
            {bandRecruitment.activityStyle ? (
              <ul className="card-content-list">
                <li className="card-content-text">
                  {bandRecruitment.activityStyleLabel}
                </li>
              </ul>
            ) : (
              <div className="card-content-text">未設定</div>
            )}
          </div>
          <div className="card-icon-container">
            <img
              className="card-icon"
              src={bandRecruitment.user.profile.avatarImage}
              alt=""
            />
            <div className="card-icon-info">
              <div className="card-icon-info-top">
                {`${bandRecruitment.user.profile.nickname} (${bandRecruitment.user.profile.part})`}
              </div>
              <div className="card-icon-info-bottom">
                {`${bandRecruitment.user.profile.calculateAge}歳 / ${bandRecruitment.user.profile.gender}`}
              </div>
            </div>
          </div>
        </div>
      </a>
    </div>
  );
};
