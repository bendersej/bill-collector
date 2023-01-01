*** Settings ***
Library    RPA.Browser.Playwright
Library    RPA.Dialogs
Library    Collections
Library    OperatingSystem
Library    String
Resource    ../helpers.robot

*** Keywords ***
Get Bill URL
    [Arguments]    ${billLink}

    ${billIdWithCustomerPrefix}=    Fetch From Right    ${billLink}    /billing/
    ${billId}=    Fetch From Left    ${billIdWithCustomerPrefix}    ?

    ${customerId}=    Execute JavaScript    window.currentUser.uuid

    [Return]    https://cloud.digitalocean.com/v2/customers/${customerId}/invoices/${billId}/pdf
Move To Next Page
    ${nextPageLink}=    Get Element    .next
    ${cssClasses}=    Get Attribute    ${nextPageLink}    class

    ${hasNextPage}=    Run Keyword And Return Status    Should Not Contain    ${cssClasses}    is-disabled

    IF    ${hasNextPage}
        Click    .next
    ELSE
        No Operation
        # Fail    Should not have been called
    END

    [Return]    ${hasNextPage}

Collect Page Bills
    ${bills}=    Create List
    ${elements}=    Get Elements    table#history tr
    FOR    ${element}    IN    @{elements}
        ${text}=    Get Text    ${element}
        ${isBillRow}=    Run Keyword And Return Status    Should Contain    ${text}    CSV
        IF    ${isBillRow}
            ${date}=    Get Text    ${element} > .date
            ${billLink}=    Get Property    ${element} > .description > a:first-of-type    href
            ${downloadURL}=    Get Bill URL    ${billLink}
            ${bill}=    Create Dictionary    invoiceNumber=None    date=${date}    downloadURL=${downloadURL}
            Append To List    ${bills}    ${bill}
        END
    END
    [Return]    ${bills}

Digital Ocean
    New Browser    chromium    headless=false
    New Context     acceptDownloads=${TRUE}    viewport={'width': 1920, 'height': 1080}
    New Page    url=https://cloud.digitalocean.com/account/billing
    Show dialog    title=Login to DigitalOcean then click close    on_top=true
    Wait all dialogs
    Wait Until Network Is Idle
    ${pageCount}=    Get Element Count    a.page.pagination-button

    FOR    ${pageNumber}    IN RANGE    ${pageCount}
      ${bills}=    Digital Ocean.Collect Page Bills

      ${selectedBills}    ${shouldExit}    Display Picker    ${bills}    TRUE
      Download Selected Bills    ${bills}    ${selectedBills}

      Exit For Loop If    "${shouldExit}" == "TRUE"

      Move To Next Page
      # TODO: Investigate why the table is not ALWAYS up to date and require this sleep
      Sleep    2s
    END

    Close Browser


