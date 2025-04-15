package models

type Log struct {
	LogID        int    `json:"log_id"`
	Action       string `json:"action"`
	TableName    string `json:"table_name"`
	RecordID     int    `json:"record_id"`
	UserID       int    `json:"user_id"`
	PreviousData string `json:"previous_data"`
	NewData      string `json:"new_data"`
	Timestamp    string `json:"timestamp"`
}
