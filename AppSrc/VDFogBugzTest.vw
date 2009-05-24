Use Windows.pkg
Use DFClient.pkg

Use cFogBugz.pkg

Deferred_View Activate_oVDFogBugzTest for ;
Object oVDFogBugzTest is a dbView

    Set Border_Style to Border_Thick
    Set Size to 189 339
    Set Location to 2 2
    
    Object oFB is a cFogBugz
    End_Object

    Object oProtocol is a ComboForm
        Set Size to 13 41
        Set Location to 4 65
        Set Entry_State to False
        Set Label to "FogBugz server:"
    
        Procedure Combo_Fill_List
            // Fill the combo list with Send Combo_Add_Item
            Send Combo_Add_Item "http://"
            Send Combo_Add_Item "https://"
        End_Procedure
    End_Object

    Object oServer is a Form
        Set Size to 13 100
        Set Location to 4 108
    End_Object

    Object oTextBox1 is a TextBox
        Set Size to 10 5
        Set Location to 5 209
        Set Label to "/"
    End_Object

    Object oPath is a Form
        Set Size to 13 100
        Set Location to 4 214
    End_Object

    Object oEmail is a Form
        Set Size to 13 100
        Set Location to 21 65
        Set Label to "E-mail address:"
    End_Object

    Object oPassword is a Form
        Set Size to 13 100
        Set Location to 38 65
        Set Password_State to True
        Set Label to "Password:"
    End_Object

    Object btnLogon is a Button
        Set Location to 55 4
        Set Label to "Logon"
    
        Procedure OnClick
            Set psProtocol of oFB to (If(Value(oProtocol(Self), 0) = "http://", fbHTTP, fbHTTPS))
            Set psHost     of oFB to (Value(oServer(Self), 0))
            Set psPath     of oFB to (Value(oPath(Self), 0))
            If (Logon(oFB(Self), Value(oEmail(Self), 0), Value(oPassword(Self), 0))) Begin
                Showln "FogBugz logon was successful"
            End
            Else Begin
                Showln "FogBugz logon failed"
            End
        End_Procedure
    End_Object

    Object btnListFilters is a Button
        Set Location to 72 4
        Set Label to "List Filters"
    
        Procedure OnClick
            tfbFilter[] aFilters
            Integer i
            
            If (ListFilters(oFB(Self), (&aFilters))) Begin
                Showln "Filters:"
                For i from 0 to (SizeOfArray(aFilters) - 1)
                    Showln "  " aFilters[i].Code " - " aFilters[i].Name
                Loop
            End
        End_Procedure
    End_Object

    Object btnListProjects is a Button
        Set Location to 72 57
        Set Label to "List Projects"
    
        Procedure OnClick
            tfbProject[] aProjects
            Integer i
            
            If (ListProjects(oFB(Self), False, (&aProjects))) Begin
                Showln "Projects:"
                For i from 0 to (SizeOfArray(aProjects) - 1)
                    Showln "  " aProjects[i].ID " - " aProjects[i].Name
                Loop
            End
        End_Procedure
    End_Object

    Object btnListIntervals is a Button
        Set Size to 14 100
        Set Location to 89 4
        Set Label to "List Intervals (last week)"
    
        Procedure OnClick
            tfbInterval[] aIntervals
            Integer i
            DateTime dtStart dtEnd
            TimeSpan tsOneWeek
            
            Move (CurrentDateTime()) to dtEnd
            Move (DateSetDay(tsOneWeek, 7)) to tsOneWeek
            Move (dtEnd - tsOneWeek) to dtStart
            
            If (ListIntervals(oFB(Self), dtStart, dtEnd, (&aIntervals))) Begin
                Showln "Intervals (in Zulu time zone):"
                For i from 0 to (SizeOfArray(aIntervals) - 1)
                    Showln "  " aIntervals[i].StartTime " - " aIntervals[i].EndTime " : " aIntervals[i].CaseTitle
                Loop
            End
        End_Procedure
    End_Object

Cd_End_Object
