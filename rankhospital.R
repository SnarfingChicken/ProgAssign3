rankhospital <- function(state, outcome, num = "best") {
        ## Read outcome data
        medData <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
        ## Check that state and outcome are valid
        stateCheck <- (medData$State == state)
        outcomeCheck <- (c("heart attack", "heart failure", "pneumonia") == outcome)
        if(any(stateCheck) == FALSE) {
                stop("invalid state")
        } else if(any(outcomeCheck) == FALSE) {
                stop("invalid outcome")
        }
  
        ## Return hospital name in that state with the given rank
        ## 30-day death rate
        stateData <- medData[medData$State == state,]
        if(outcome == "heart attack") {
                stateData <- stateData[stateData$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack != "Not Available",]
                stateData[, 11] <- as.numeric(as.character(stateData[, 11]))
                stateData <- stateData[order(stateData$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack, stateData$Hospital.Name),]
        } else if(outcome == "heart failure") {
                stateData <- stateData[stateData$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure != "Not Available",]
                stateData[, 17] <- as.numeric(as.character(stateData[, 17]))
                stateData <- stateData[order(stateData$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure, stateData$Hospital.Name),]
        } else {
                stateData <- stateData[stateData$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia != "Not Available",]
                stateData[, 23] <- as.numeric(as.character(stateData[, 23]))
                stateData <- stateData[order(stateData$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia, stateData$Hospital.Name),]
        }
        
        if(num == "worst" | num == length(stateData[, 11])) {
                stateData[length(stateData[, 11]), 2]
        } else if(num == "best" | num == 1) {
                stateData[1, 2]
        } else if(num > 1 | num < length(stateData[, 11])) {
                stateData[num, 2]
        } else {
                return(NA)
        }
}