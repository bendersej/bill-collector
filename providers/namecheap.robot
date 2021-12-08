*** Settings ***
Library    RPA.Browser.Playwright
Library    RPA.Dialogs
Library    Collections
Library    OperatingSystem
Library    DateTime
Resource    ../helpers.robot


*** Keywords ***
Get Last 10 Years Invoices
    Click    .dropdown .show-calendar
    ${currentDate}=    Get Current Date
    ${10YearsAgo}=    Add Time To Date    ${currentDate}    -3650 day    %m/%d/%Y
    Fill Text    .daterangepicker_start_input .input-mini    ${10YearsAgo}
    Click    .applyBtn

Select All Pages
    Click    .pagination-small
    Click    .pagination-small .dropdown-content li:last-of-type a.top-pagesize-change



Collect Page Bills
    ${bills}=    Create List
    ${elements}=    Get Elements    table tr.with-extra-row
    FOR    ${element}    IN    @{elements}
        ${invoiceNumber}=    Get Text    ${element} > td:nth-of-type(1)
        ${date}=    Get Text    ${element} > td:nth-of-type(3)
        ${downloadURL}=    Get Property    ${element} > td.text-right ul.dropdown li:last-of-type a    href
        ${bill}=    Create Dictionary    invoiceNumber=${invoiceNumber}    date=${date}    downloadURL=${downloadURL}
        Append To List    ${bills}    ${bill}
    END
    [Return]    ${bills}

Namecheap
    New Browser    chromium    headless=false
    New Context     acceptDownloads=${TRUE}    viewport={'width': 1920, 'height': 1080}
    New Page    url=https://www.namecheap.com/myaccount/login/
    Show dialog    title=Login to Namecheap then click close    on_top=true
    Wait all dialogs
    Wait Until Network Is Idle

    Go To    https://ap.www.namecheap.com/Profile/Billing/Orders

    Get Last 10 Years Invoices
    Select All Pages

    ${bills}=    Namecheap.Collect Page Bills

    ${selectedBills}    ${shouldExit}     Display Picker    ${bills}    FALSE
    Download Selected Bills    ${bills}    ${selectedBills}
    Close Browser