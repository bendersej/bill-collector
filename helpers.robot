*** Settings ***
Library    RPA.Browser.Playwright
Library    RPA.Dialogs
Library    OperatingSystem

*** Keywords ***
Get Providers
    ${providers}=    Create List    Digital Ocean

    [Return]    ${providers}

Display Picker
  [Arguments]    ${bills}
  Add heading     Bills to collect
  FOR    ${bill}    IN    @{bills}
      ${billDate}=    Set Variable    ${bill["date"]}
      Add checkbox    name=${billDate}        label=${billDate}       default=False
  END

  Add submit buttons    buttons=Get older bills, Done

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
        ${billDate}=    Set Variable    ${bill["date"]}
        IF    ${selectedBills}[${billDate}]
            ${file}=    Download    ${bill}[downloadURL]
            Move File    ${file}[saveAs]    %{ROBOT_ARTIFACTS}/bills/${billDate}.pdf
        END
    END

Select Provider
    ${supportedProviders}=    Get Providers

    Add drop-down    provider    ${supportedProviders}

    ${result}=    Run dialog

    [Return]    ${result.provider}