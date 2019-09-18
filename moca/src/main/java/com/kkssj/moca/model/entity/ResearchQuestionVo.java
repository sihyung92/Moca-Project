package com.kkssj.moca.model.entity;

public class ResearchQuestionVo {
	int question_id;
	String question, category,answer;
	
	public ResearchQuestionVo() {
		// TODO Auto-generated constructor stub
	}

	public ResearchQuestionVo(int question_id, String question, String category, String answer) {
		super();
		this.question_id = question_id;
		this.question = question;
		this.category = category;
		this.answer = answer;
	}

	public int getQuestion_id() {
		return question_id;
	}

	public void setQuestion_id(int question_id) {
		this.question_id = question_id;
	}

	public String getQuestion() {
		return question;
	}

	public void setQuestion(String question) {
		this.question = question;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getAnswer() {
		return answer;
	}

	public void setAnswer(String answer) {
		this.answer = answer;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((answer == null) ? 0 : answer.hashCode());
		result = prime * result + ((category == null) ? 0 : category.hashCode());
		result = prime * result + ((question == null) ? 0 : question.hashCode());
		result = prime * result + question_id;
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		ResearchQuestionVo other = (ResearchQuestionVo) obj;
		if (answer == null) {
			if (other.answer != null)
				return false;
		} else if (!answer.equals(other.answer))
			return false;
		if (category == null) {
			if (other.category != null)
				return false;
		} else if (!category.equals(other.category))
			return false;
		if (question == null) {
			if (other.question != null)
				return false;
		} else if (!question.equals(other.question))
			return false;
		if (question_id != other.question_id)
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "ResearchQuestionVo [question_id=" + question_id + ", question=" + question + ", category=" + category
				+ ", answer=" + answer + "]";
	}
	
}
