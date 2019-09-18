package com.kkssj.moca.model.entity;

public class ResearchVo {

	int research_id, account_id, checkcode;
	String answer;
	
	public ResearchVo() {
		
	}

	public ResearchVo(int research_id, int account_id, int checkcode, String answer) {
		super();
		this.research_id = research_id;
		this.account_id = account_id;
		this.checkcode = checkcode;
		this.answer = answer;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + account_id;
		result = prime * result + ((answer == null) ? 0 : answer.hashCode());
		result = prime * result + checkcode;
		result = prime * result + research_id;
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
		ResearchVo other = (ResearchVo) obj;
		if (account_id != other.account_id)
			return false;
		if (answer == null) {
			if (other.answer != null)
				return false;
		} else if (!answer.equals(other.answer))
			return false;
		if (checkcode != other.checkcode)
			return false;
		if (research_id != other.research_id)
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "ResearchVo [research_id=" + research_id + ", account_id=" + account_id + ", checkcode=" + checkcode
				+ ", answer=" + answer + "]";
	}

	public int getResearch_id() {
		return research_id;
	}

	public void setResearch_id(int research_id) {
		this.research_id = research_id;
	}

	public int getAccount_id() {
		return account_id;
	}

	public void setAccount_id(int account_id) {
		this.account_id = account_id;
	}

	public int getCheckcode() {
		return checkcode;
	}

	public void setCheckcode(int checkcode) {
		this.checkcode = checkcode;
	}

	public String getAnswer() {
		return answer;
	}

	public void setAnswer(String answer) {
		this.answer = answer;
	}
	
}
