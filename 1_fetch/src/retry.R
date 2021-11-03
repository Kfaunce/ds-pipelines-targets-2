retry <- function(expr, isError=function(x) "try-error" %in% class(x), maxErrors, sleep) { 
  
  # function to retry downloads within set number of attempts and wait period
  
  attempts = 0
  retval = try(eval(expr))
  
  while (isError(retval)) {
    
    attempts = attempts + 1
    if (attempts >= maxErrors) {
      msg = sprintf("retry: too many retries [[%s]]", capture.output(str(retval)))
      flog.fatal(msg)
      stop(msg)
      
    } else {
      
      msg = sprintf("retry: error in attempt %i/%i [[%s]]", attempts, maxErrors, capture.output(str(retval)))
      futile.logger::flog.error(msg)
      warning(msg)
      
    }
    
    if (sleep > 0) Sys.sleep(sleep)
    retval = try(eval(expr))
    
  }
  
  return(retval)
  
}