export type CurrentUserProps = {
  signedIn: boolean;
};

export type BandRecruitmentProps = {
  id: number;
  user: {
    userId: number;
    profile: {
      nickname: string;
      part: string;
      calculateAge: string;
      gender: string;
      avatarImage: string;
    };
  };
  teamName: string | null;
  title: string;
  activityStyle: number | null;
  activityStyleLabel: string | null;
  practiceFrequencyUnit: number | null;
  practiceFrequencyUnitLabel: string | null;
  practiceFrequencyCount: number | null;
  practiceStyle: number | null;
  practiceStyleLabel: string | null;
  musicType: number | null;
  musicTypeLabel: string | null;
  wantsLivePerformance: boolean | null;
  deadline: string | null;
  status: number | null;
  statusLabel: string;
  comment: string | null;
  recruitmentParts: {
    id: number;
    bandRecruitmentId: number;
    part: number;
    maxCount: number;
    full: boolean;
  }[];
  activityGenres: {
    id: number;
    name: string;
  }[];
  activityAreas: {
    id: number;
    name: string;
  }[];
  isOwner: boolean;
  recruitmentCompatibility: number;
  hasApprovedApplications: boolean;
  approvedApplicationsCount: number;
};

// 一つの募集
export type RecruitmentCardProps = {
  currentUser: CurrentUserProps;
  bandRecruitment: BandRecruitmentProps;
};

// 全ての募集
export type RecruitmentResponse = {
  currentUser: CurrentUserProps;
  bandRecruitments: BandRecruitmentProps[];
};
