*** Settings ***
Library    RPA.Browser.Playwright
Library    RPA.Dialogs
Library    Collections
Library    OperatingSystem
Resource    ../helpers.robot


*** Keywords ***
Collect Page Bills
    ${bills}=    Create List
    ${elements}=    Get Elements    table tr[data-test]
    FOR    ${element}    IN    @{elements}
        ${invoiceNumber}=    Get Text    ${element} [data-test=invoice-number]
        ${date}=    Get Text    ${element} [data-test=invoice-date]
        ${downloadURL}=    Get Property    ${element} > td a    href
        ${bill}=    Create Dictionary    invoiceNumber=${invoiceNumber}    date=${date}    downloadURL=${downloadURL}
        Append To List    ${bills}    ${bill}
    END
    [Return]    ${bills}

Pipedrive
    New Browser    chromium    headless=false
    New Context     acceptDownloads=${TRUE}    viewport={'width': 1920, 'height': 1080}
    New Page    url=https://app.pipedrive.com/auth/login
    Show dialog    title=Login to Pipedrive then click close    on_top=true
    Wait all dialogs
    Wait Until Network Is Idle

    ${origin}=    Execute JavaScript    window.location.origin

    Go To    ${origin}/settings/subscription/invoices

    ${bills}=    Pipedrive.Collect Page Bills

    ${selectedBills}    ${shouldExit}     Display Picker    ${bills}    FALSE
    Download Selected Bills    ${bills}    ${selectedBills}
    Close Browser