# TestApplication

## To do

Tasks can be self-assigned using shortened names: AS, JS, MM.

- Write software application
    - [ ] Create template for report - *MM*
        - [ ] Short summary of test phase (check ER Prüfgerät LiIonCheck9V125mA )
        - [ ] Discharge curve (e.g. similar to image 7 in ER-LiIonCheck9V125mA )
        - [ ] Capacity: minimum - actual pass/fail
        - [ ] Voltage: actual value pass/fail
        - [ ] Current: actual value pass/fail
        - [ ] Maximum discharge voltage pass/fail
        - [ ] Minimum discharge voltage pass/fail
        - [ ] Display any implausible values
        - [ ] Signature log: name, date, signature
    - [ ] Input validation
        - [ ] input arguments
        - [ ] file accessibility
        - [ ] input file type and content (rough estimation)
    - [ ] Parameter testing - *AS*
        - [ ] Voltage
        - [ ] Current
        - [ ] Capacity
        - [ ] Implausibility of data
    - [ ] create CLI for specifying input
- Create a test environment
    - Needs to be separate application? 
    - Connect Arduino with R [possible guide](https://rstudio-pubs-static.s3.amazonaws.com/727970_e305535f79e04e958bfd0dfe444b40d1.html)
    - Consider possible failures not covered in testdata. How can it be improved
- Documentation of software application (Engineering Report) - *JS*
    - [ ] Purpose 
    - [ ] Requirements
    - [ ] Implementation 
    - [ ] Test cases & results
    - [ ] Conclusion 
