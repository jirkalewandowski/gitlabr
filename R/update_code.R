#' Convert gitlabr legacy code to 0.7 compatible
#' 
#' CAUTION: This functions output/results should be checked manually before
#' committing the code, since it uses regular expression heuristically
#' to parse code and cannot guarantee complete and correct code replacement
#' 
#' @param text lines of code to convert
#' @param file file to read from/write to. Maybe NULL for input and return only
#' @export
update_gitlabr_code <- function(file,
                                text = readLines(file)) {
  
  data("gitlabr_0_7_renaming")
  
  gitlabr_0_7_renaming %$%
    mapply(partial,
           pattern = paste0("(", old_name, ")(\\s*)(\\(|,|$)"),
           replacement = paste0(new_name, "\\2\\3"),
           MoreArgs = list(...f = gsub, .lazy = FALSE, .first = FALSE),
           USE.NAMES = FALSE, SIMPLIFY = FALSE) %>%
    reduce(.f = function(prv, nxt) {
      nxt(prv)
    }, .init = text) %>%
    iffn(is.null(file), writeLines, file)
  
}