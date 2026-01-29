package de.dhsn.wissentest.model;

import java.util.List;

public class AttemptResult {
    private Attempt attempt;
    private List<QuestionResultDetail> details;
    private Integer recommendedDifficulty;

    public AttemptResult(Attempt attempt, List<QuestionResultDetail> details) {
        this.attempt = attempt;
        this.details = details;
    }

    public Attempt getAttempt() { return attempt; }
    public List<QuestionResultDetail> getDetails() { return details; }
    public Integer getRecommendedDifficulty() { return recommendedDifficulty; }
    public void setRecommendedDifficulty(Integer recommendedDifficulty) {
        this.recommendedDifficulty = recommendedDifficulty;
    }
}
