/*
 * Datei: AdminService.java
 * Diese Klasse bündelt alle Admin-Funktionen rund um Fragen: anlegen, aktualisieren und die dazu
 * passenden Antwortoptionen bzw. Tokens speichern. Damit bleibt die Servlet-Schicht schlank und
 * der Datenbankzugriff sauber getrennt.
 * Verbindung: Nutzt QuestionRepository, AnswerDao, ClozeTokenDao; verwendet in AdminServlet.
 */
package de.dhsn.wissentest.service;

import de.dhsn.wissentest.dao.AnswerDao;
import de.dhsn.wissentest.dao.ClozeTokenDao;
import de.dhsn.wissentest.dao.QuestionRepository;
import de.dhsn.wissentest.model.AnswerOption;
import de.dhsn.wissentest.model.ClozeToken;
import de.dhsn.wissentest.model.Question;
import de.dhsn.wissentest.model.QuestionType;

import java.util.List;

public class AdminService {
    private final QuestionRepository questionDao;
    private final AnswerDao answerDao;
    private final ClozeTokenDao clozeTokenDao;

    public AdminService(QuestionRepository questionDao, AnswerDao answerDao, ClozeTokenDao clozeTokenDao) {
        this.questionDao = questionDao;
        this.answerDao = answerDao;
        this.clozeTokenDao = clozeTokenDao;
    }

    public int createMultipleChoiceQuestion(Question question, List<AnswerOption> answers) {
        question.setType(QuestionType.MC);
        int questionId = questionDao.create(question);
        for (AnswerOption option : answers) {
            option.setQuestionId(questionId);
            answerDao.create(option);
        }
        return questionId;
    }

    public void updateMultipleChoiceQuestion(Question question, List<AnswerOption> answers) {
        question.setType(QuestionType.MC);
        questionDao.update(question);
        answerDao.deleteByQuestion(question.getId());
        for (AnswerOption option : answers) {
            option.setQuestionId(question.getId());
            answerDao.create(option);
        }
    }

    public int createClozeQuestion(Question question, List<ClozeToken> tokens) {
        question.setType(QuestionType.CLOZE);
        int questionId = questionDao.create(question);
        for (ClozeToken token : tokens) {
            token.setQuestionId(questionId);
            clozeTokenDao.create(token);
        }
        return questionId;
    }

    public void updateClozeQuestion(Question question, List<ClozeToken> tokens) {
        question.setType(QuestionType.CLOZE);
        questionDao.update(question);
        clozeTokenDao.deleteByQuestion(question.getId());
        for (ClozeToken token : tokens) {
            token.setQuestionId(question.getId());
            clozeTokenDao.create(token);
        }
    }
}
