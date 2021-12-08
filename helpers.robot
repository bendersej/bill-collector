*** Settings ***
Library    RPA.Browser.Playwright
Library    RPA.Dialogs
Library    OperatingSystem

*** Keywords ***
Get Providers
    ${providers}=    Create List    Digital Ocean    Pipedrive    Namecheap

    [Return]    ${providers}

Get Invoice Id
    [Arguments]    ${date}    ${invoiceNumber}

    ${invoiceId}=    Evaluate    "${date}${invoiceNumber}".replace(' ', '_').replace('#', '')

    [Return]    ${invoiceId}

Get Invoice Label
    [Arguments]    ${date}    ${invoiceNumber}

    IF    "${invoiceNumber}" == "None"
        ${invoiceLabel}=    Set Variable    ${date}
    ELSE
        ${invoiceLabel}=    Set Variable    ${date} - ${invoiceNumber}
    END

    [Return]    ${invoiceLabel}


Display Picker
  [Arguments]    ${bills}    ${hasMorePages}
  Add heading     Bills to collect
  FOR    ${bill}    IN    @{bills}
      ${invoiceNumber}=    Set Variable    ${bill["invoiceNumber"]}
      ${billDate}=    Set Variable    ${bill["date"]}
      ${billId}=    Get Invoice Id    ${billDate}    ${invoiceNumber}
      ${invoiceLabel}=    Get Invoice Label    ${billDate}    ${invoiceNumber}
      Add checkbox    name=${billId}        label=${invoiceLabel}       default=False
  END

  IF  "${hasMorePages}" == "TRUE"
      Add submit buttons    buttons=Get older bills, Done
  END

  ${selectedBills}=      Run dialog

  IF    "${selectedBills.submit}" == "Done"
      ${shouldExit}=    Set Variable    TRUE
  ELSE
      ${shouldExit}=    Set Variable    FALSE
  END

  [Return]    ${selectedBills}    ${shouldExit}

Download Selected Bills
    [Arguments]    ${bills}    ${selectedBills}
    FOR    ${bill}    IN    @{bills}
        ${invoiceNumber}=    Set Variable    ${bill["invoiceNumber"]}
        ${billDate}=    Set Variable    ${bill["date"]}
        ${billId}=    Get Invoice Id    ${billDate}    ${invoiceNumber}

        IF    ${selectedBills}[${billId}]
            ${file}=    Download    ${bill}[downloadURL]
            ${invoiceLabel}=    Get Invoice Label    ${billDate}    ${invoiceNumber}
            Move File    ${file}[saveAs]    %{ROBOT_ARTIFACTS}/bills/${invoiceLabel}.pdf
        END
    END

Select Provider
    ${supportedProviders}=    Get Providers

    Add drop-down    provider    ${supportedProviders}

    ${result}=    Run dialog

    [Return]    ${result.provider}