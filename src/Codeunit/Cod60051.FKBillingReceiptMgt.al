/// <summary>
/// Codeunit FK Billing - Receipt Mgt. (ID 60051).
/// </summary>
codeunit 60051 "FK Billing - Receipt Mgt."
{

    Permissions = TableData "Cust. Ledger Entry" = imd, tabledata "Vendor Ledger Entry" = imd;
    /// <summary>
    /// TPP SetDocument.
    /// </summary>
    /// <param name="BillRcptHeader">Record "TPP Billing - Receipt Header".</param>
    procedure "TPP SetDocument"(BillRcptHeader: Record "TPP Billing - Receipt Header")
    begin
        BillingRcptHeader.GET(BillRcptHeader."TPP Document Type", BillRcptHeader."TPP No.");
    end;

    /// <summary>
    /// TPP UpdateCustOutstanding.
    /// </summary>
    /// <param name="CustEntryNo">Integer.</param>
    procedure "TPP UpdateCustOutstanding"(CustEntryNo: Integer)
    var
        IsHandled: Boolean;
        RecRemAmount: Decimal;
    begin
        // Ton 2022-04-27 ++
        IsHandled := false;
        OnBeforeUpdateCustOutstanding(CustEntryNo, IsHandled);
        if IsHandled then
            exit;
        // Ton 2022-04-27 --

        //TPP.SSI 2022/06/01++
        Clear(RecRemAmount);
        RecRemAmount := FKFunc.GETCustRecRemAmt(CustEntryNo);
        //TPP.SSI 2022/06/01--

        IF CustLedgEntry.GET(CustEntryNo) THEN BEGIN
            CustLedgEntry.CALCFIELDS("Amount (LCY)", "TPP Cust. Rec. Amount (LCY)", "Remaining Amt. (LCY)");
            CustLedgEntry."TPP Cust. Rec. Rem. Amt. (LCY)" := RecRemAmount - CustLedgEntry."TPP Cust. Rec. Amount (LCY)";
            IF (CustLedgEntry."TPP Cust. Rec. Rem. Amt. (LCY)" <> 0) AND (RecRemAmount <> 0) THEN
                CustLedgEntry."TPP Cust. Rec. Open" := TRUE
            ELSE
                CustLedgEntry."TPP Cust. Rec. Open" := FALSE;
            FKFunc.SetData1stInsert(true);
            CustLedgEntry.MODIFY();
        END;
    end;

    /// <summary>
    /// TPP UpdateCustOutstandingfromdel.
    /// </summary>
    /// <param name="CustEntryNo">Integer.</param>
    /// <param name="AmountLCY">Decimal.</param>
    procedure "TPP UpdateCustOutstandingfromdel"(CustEntryNo: Integer; AmountLCY: Decimal)
    var
        IsHandled: Boolean;
        RecRemAmount: Decimal;
    begin
        // Ton 2022-04-27 ++
        IsHandled := false;
        OnBeforeUpdateCustOutstandingfromdel(CustEntryNo, AmountLCY, IsHandled);
        if IsHandled then
            exit;
        // Ton 2022-04-27 --

        //TPP.SSI 2022/06/01++
        Clear(RecRemAmount);
        RecRemAmount := FKFunc.GETCustRecRemAmt(CustEntryNo);
        //TPP.SSI 2022/06/01--


        // IF AmountLCY <> 0 THEN BEGIN //Commment TPP.SSI 2021/02/08
        IF CustLedgEntry.GET(CustEntryNo) THEN BEGIN
            CustLedgEntry.CALCFIELDS("Amount (LCY)", "TPP Cust. Rec. Amount (LCY)", "Remaining Amt. (LCY)",
            "TPP Cust. Billing Amount (LCY)");
            CustLedgEntry."TPP Cust. Rec. Rem. Amt. (LCY)" := RecRemAmount - CustLedgEntry."TPP Cust. Rec. Amount (LCY)" + AmountLCY;
            IF (CustLedgEntry."TPP Cust. Rec. Rem. Amt. (LCY)" <> 0) AND (RecRemAmount <> 0) THEN
                CustLedgEntry."TPP Cust. Rec. Open" := TRUE
            ELSE
                CustLedgEntry."TPP Cust. Rec. Open" := FALSE;
            FKFunc.SetData1stInsert(true);
            CustLedgEntry.MODIFY();
        END;
        // END;
    end;

    /// <summary>
    /// TPP UpdateCustOutstandingfromrec.
    /// </summary>
    /// <param name="CustEntryNo">Integer.</param>
    /// <param name="AmountLCY">Decimal.</param>
    /// <param name="OldAmountLCY">Decimal.</param>
    procedure "TPP UpdateCustOutstandingfromrec"(CustEntryNo: Integer; AmountLCY: Decimal; OldAmountLCY: Decimal)
    var
        IsHandled: Boolean;
        RecRemAmount: Decimal;
    begin
        // Ton 2022-04-27 ++
        IsHandled := false;
        OnBeforeUpdateCustOutstandingfromrec(CustEntryNo, AmountLCY, OldAmountLCY, IsHandled);
        if IsHandled then
            exit;
        // Ton 2022-04-27 --


        //TPP.SSI 2022/06/01++
        Clear(RecRemAmount);
        RecRemAmount := FKFunc.GETCustRecRemAmt(CustEntryNo);
        //TPP.SSI 2022/06/01--


        // IF AmountLCY <> 0 THEN BEGIN
        IF CustLedgEntry.GET(CustEntryNo) THEN BEGIN
            CustLedgEntry.CALCFIELDS("Amount (LCY)", "TPP Cust. Rec. Amount (LCY)", "Remaining Amt. (LCY)");
            IF RecRemAmount < (CustLedgEntry."TPP Cust. Rec. Amount (LCY)" - OldAmountLCY + AmountLCY) THEN
                ERROR('Ledger Remaining Amt. (LCY) must less than %1', RecRemAmount - (CustLedgEntry."TPP Cust. Rec. Amount (LCY)" - OldAmountLCY));
            CustLedgEntry."TPP Cust. Rec. Rem. Amt. (LCY)" := RecRemAmount - (CustLedgEntry."TPP Cust. Rec. Amount (LCY)" - OldAmountLCY + AmountLCY);
            IF (CustLedgEntry."TPP Cust. Rec. Rem. Amt. (LCY)" <> 0) AND (RecRemAmount <> 0) THEN
                CustLedgEntry."TPP Cust. Rec. Open" := TRUE
            ELSE
                CustLedgEntry."TPP Cust. Rec. Open" := FALSE;
            FKFunc.SetData1stInsert(true);
            CustLedgEntry.MODIFY();
        END;
        // END;
    end;

    /// <summary>
    /// TPP UpdateCustOutstandingBilling.
    /// </summary>
    /// <param name="CustEntryNo">Integer.</param>
    procedure "TPP UpdateCustOutstandingBilling"(CustEntryNo: Integer)
    var
        IsHandled: Boolean;
    begin
        // Ton 2022-04-27 ++
        IsHandled := false;
        OnBeforeCustOutstandingBilling(CustEntryNo, IsHandled);
        if IsHandled then
            exit;
        // Ton 2022-04-27 --

        IF CustLedgEntry.GET(CustEntryNo) THEN BEGIN
            CustLedgEntry.CALCFIELDS("Amount (LCY)", "TPP Cust. Billing Amount (LCY)", "Remaining Amt. (LCY)");
            CustLedgEntry."TPP Cust. Bill. Rem. Amt.(LCY)" := CustLedgEntry."Remaining Amt. (LCY)" - CustLedgEntry."TPP Cust. Billing Amount (LCY)";
            IF (CustLedgEntry."TPP Cust. Bill. Rem. Amt.(LCY)" <> 0) AND (CustLedgEntry."Remaining Amt. (LCY)" <> 0) THEN
                CustLedgEntry."TPP Cust. Billing Open" := TRUE
            ELSE
                CustLedgEntry."TPP Cust. Billing Open" := FALSE;
            FKFunc.SetData1stInsert(true);
            CustLedgEntry.MODIFY();
        END;
    end;

    /// <summary>
    /// TPP UpdateCustOutstandingfromdelBilling.
    /// </summary>
    /// <param name="CustEntryNo">Integer.</param>
    /// <param name="AmountLCY">Decimal.</param>
    procedure "TPP UpdateCustOutstandingfromdelBilling"(CustEntryNo: Integer; AmountLCY: Decimal)
    var
        IsHandled: Boolean;
    begin
        // Ton 2022-04-27 ++
        IsHandled := false;
        OnBeforeUpdateCustOutstandingfromdelBilling(CustEntryNo, AmountLCY, IsHandled);
        if IsHandled then
            exit;
        // Ton 2022-04-27 --

        // IF AmountLCY <> 0 THEN BEGIN //Commment TPP.SSI 2021/02/08
        IF CustLedgEntry.GET(CustEntryNo) THEN BEGIN
            CustLedgEntry.CALCFIELDS("Amount (LCY)", "TPP Cust. Rec. Amount (LCY)", "Remaining Amt. (LCY)", "TPP Cust. Billing Amount (LCY)");
            CustLedgEntry."TPP Cust. Bill. Rem. Amt.(LCY)" := CustLedgEntry."Remaining Amt. (LCY)" - CustLedgEntry."TPP Cust. Billing Amount (LCY)" + AmountLCY;
            IF (CustLedgEntry."TPP Cust. Bill. Rem. Amt.(LCY)" <> 0) AND (CustLedgEntry."Remaining Amt. (LCY)" <> 0) THEN
                CustLedgEntry."TPP Cust. Billing Open" := TRUE
            ELSE
                CustLedgEntry."TPP Cust. Billing Open" := FALSE;
            FKFunc.SetData1stInsert(true);
            CustLedgEntry.MODIFY();
        END;
        // END;
    end;

    /// <summary>
    /// TPP UpdateCustOutstandingfromrecBilling.
    /// </summary>
    /// <param name="CustEntryNo">Integer.</param>
    /// <param name="AmountLCY">Decimal.</param>
    /// <param name="OldAmountLCY">Decimal.</param>
    procedure "TPP UpdateCustOutstandingfromrecBilling"(CustEntryNo: Integer; AmountLCY: Decimal; OldAmountLCY: Decimal)
    var
        IsHandled: Boolean;
    begin
        // Ton 2022-04-27 ++
        IsHandled := false;
        OnBeforeUpdateCustOutstandingfromrecBilling(CustEntryNo, AmountLCY, OldAmountLCY, IsHandled);
        if IsHandled then
            exit;
        // Ton 2022-04-27 --

        // IF AmountLCY <> 0 THEN BEGIN
        IF CustLedgEntry.GET(CustEntryNo) THEN BEGIN
            CustLedgEntry.CALCFIELDS("Amount (LCY)", "TPP Cust. Billing Amount (LCY)", "Remaining Amt. (LCY)");
            IF CustLedgEntry."Amount (LCY)" < (CustLedgEntry."TPP Cust. Billing Amount (LCY)" - OldAmountLCY + AmountLCY) THEN
                ERROR('Cust Ledger Remaining Amt. (LCY) must less than %1', CustLedgEntry."Remaining Amt. (LCY)" - (CustLedgEntry."TPP Cust. Billing Amount (LCY)" - OldAmountLCY));
            CustLedgEntry."TPP Cust. Bill. Rem. Amt.(LCY)" := CustLedgEntry."Remaining Amt. (LCY)" - (CustLedgEntry."TPP Cust. Billing Amount (LCY)" - OldAmountLCY + AmountLCY);
            IF (CustLedgEntry."TPP Cust. Bill. Rem. Amt.(LCY)" <> 0) AND (CustLedgEntry."Remaining Amt. (LCY)" <> 0) THEN
                CustLedgEntry."TPP Cust. Billing Open" := TRUE
            ELSE
                CustLedgEntry."TPP Cust. Billing Open" := FALSE;
            FKFunc.SetData1stInsert(true);
            CustLedgEntry.MODIFY();
        END;
        // END;
    end;


    //TPP.SSI 2022/03/18++
    /// <summary>
    /// TPP UpdateVendOutstanding.
    /// </summary>
    /// <param name="VendEntryNo">Integer.</param>
    procedure "TPP UpdateVendOutstanding"(VendEntryNo: Integer)
    var
        IsHandled: Boolean;
    begin
        // Ton 2022-04-27 ++
        IsHandled := false;
        OnBeforeUpdateVendOutstanding(VendEntryNo, IsHandled);
        if IsHandled then
            exit;
        // Ton 2022-04-27 --

        IF VendLedgerEntry.GET(VendEntryNo) THEN BEGIN
            VendLedgerEntry.CALCFIELDS("Amount (LCY)", "TPP Vend. Bill. Amount (LCY)", "Remaining Amt. (LCY)");
            VendLedgerEntry."TPP Vend. Bill. Rem. Amt.(LCY)" := VendLedgerEntry."Remaining Amt. (LCY)" - (VendLedgerEntry."TPP Vend. Bill. Amount (LCY)");
            IF (VendLedgerEntry."TPP Vend. Bill. Rem. Amt.(LCY)" <> 0) AND (VendLedgerEntry."Remaining Amt. (LCY)" <> 0) THEN
                VendLedgerEntry."TPP Vend. Billing Open" := TRUE
            ELSE
                VendLedgerEntry."TPP Vend. Billing Open" := FALSE;
            FKFunc.SetData1stInsert(true);
            VendLedgerEntry.MODIFY();
        END;
    end;

    /// <summary>
    /// TPP UpdateVendOutstandingfromdel.
    /// </summary>
    /// <param name="VendEntryNo">Integer.</param>
    /// <param name="AmountLCY">Decimal.</param>
    procedure "TPP UpdateVendOutstandingfromdel"(VendEntryNo: Integer; AmountLCY: Decimal)
    var
        IsHandled: Boolean;
    begin
        // Ton 2022-04-27 ++
        IsHandled := false;
        OnBeforeUpdateVendOutstandingfromdel(VendEntryNo, AmountLCY, IsHandled);
        if IsHandled then
            exit;
        // Ton 2022-04-27 --

        // IF AmountLCY <> 0 THEN BEGIN
        IF VendLedgerEntry.GET(VendEntryNo) THEN BEGIN
            VendLedgerEntry.CALCFIELDS("Amount (LCY)", "TPP Vend. Bill. Amount (LCY)", "Remaining Amt. (LCY)");
            VendLedgerEntry."TPP Vend. Bill. Rem. Amt.(LCY)" := VendLedgerEntry."Remaining Amt. (LCY)" - VendLedgerEntry."TPP Vend. Bill. Amount (LCY)" - AmountLCY;
            IF (VendLedgerEntry."TPP Vend. Bill. Rem. Amt.(LCY)" <> 0) AND (VendLedgerEntry."Remaining Amt. (LCY)" <> 0) THEN
                VendLedgerEntry."TPP Vend. Billing Open" := TRUE
            ELSE
                VendLedgerEntry."TPP Vend. Billing Open" := FALSE;
            FKFunc.SetData1stInsert(true);
            VendLedgerEntry.MODIFY();
        END;
        // end;
    end;

    /// <summary>
    /// TPP UpdateVendOutstandingfromrec.
    /// </summary>
    /// <param name="VendEntryNo">Integer.</param>
    /// <param name="AmountLCY">Decimal.</param>
    /// <param name="OldAmountLCY">Decimal.</param>
    procedure "TPP UpdateVendOutstandingfromrec"(VendEntryNo: Integer; AmountLCY: Decimal; OldAmountLCY: Decimal)
    var
        IsHandled: Boolean;
    begin
        // Ton 2022-04-27 ++
        IsHandled := false;
        OnBeforeUpdateVendOutstandingfromrec(VendEntryNo, AmountLCY, OldAmountLCY, IsHandled);
        if IsHandled then
            exit;
        // Ton 2022-04-27 --

        // IF AmountLCY <> 0 THEN BEGIN
        IF VendLedgerEntry.GET(VendEntryNo) THEN BEGIN
            VendLedgerEntry.CALCFIELDS("Amount (LCY)", "TPP Vend. Bill. Amount (LCY)", "Remaining Amt. (LCY)");
            IF VendLedgerEntry."Remaining Amt. (LCY)" > (VendLedgerEntry."TPP Vend. Bill. Amount (LCY)" + (OldAmountLCY - AmountLCY)) THEN
                ERROR('Vendor Ledger Remaining Amt. (LCY) must less than %1', VendLedgerEntry."Remaining Amt. (LCY)" - (VendLedgerEntry."TPP Vend. Bill. Amount (LCY)" + OldAmountLCY));
            VendLedgerEntry."TPP Vend. Bill. Rem. Amt.(LCY)" := VendLedgerEntry."Remaining Amt. (LCY)" - (VendLedgerEntry."TPP Vend. Bill. Amount (LCY)" + (OldAmountLCY - AmountLCY));
            IF (VendLedgerEntry."TPP Vend. Bill. Rem. Amt.(LCY)" <> 0) AND (VendLedgerEntry."Remaining Amt. (LCY)" <> 0) THEN
                VendLedgerEntry."TPP Vend. Billing Open" := TRUE
            ELSE
                VendLedgerEntry."TPP Vend. Billing Open" := FALSE;

            FKFunc.SetData1stInsert(true);
            VendLedgerEntry.MODIFY();
        END;
        // END;
    end;
    //TPP.SSI 2022/03/18--

    /// <summary>
    /// TPP GetVendLedgEntry.
    /// </summary>
    procedure "TPP GetVendLedgEntry"()
    var
        VendorLedgEntry: Record "Vendor Ledger Entry";
        VendEntryPage: Page "FK Vendor Ledger Page";
    begin
        VendorLedgEntry.RESET();
        VendorLedgEntry.SETCURRENTKEY("Vendor No.", "Posting Date", "Currency Code");
        VendorLedgEntry.SETRANGE("Vendor No.", BillingRcptHeader."TPP Vendor No.");
        VendorLedgEntry.SETRANGE("TPP Vend. Billing Open", TRUE); //TPP.SSI 2022/03/18
        VendorLedgEntry.SETFILTER("Currency Code", '%1', BillingRcptHeader."TPP Currency Code");
        VendorLedgEntry.SETFILTER(Open, '%1', TRUE);
        OnAfterFilterGetVendLedgEntry(BillingRcptHeader, VendorLedgEntry); // Ton 2021-08-07

        VendEntryPage.SETTABLEVIEW(VendorLedgEntry);
        VendEntryPage.LOOKUPMODE := TRUE;
        VendEntryPage.SetDocument(BillingRcptHeader);
        VendEntryPage.RUNMODAL();
    end;




    [IntegrationEvent(false, false)]
    local procedure OnAfterFilterGetVendLedgEntry(BillRcptHeader: Record "TPP Billing - Receipt Header"; var VendorLedgEntry: Record "Vendor Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateCustOutstanding(CustEntryNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateCustOutstandingfromdel(CustEntryNo: Integer; AmountLCY: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateCustOutstandingfromrec(CustEntryNo: Integer; AmountLCY: Decimal; OldAmountLCY: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCustOutstandingBilling(CustEntryNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateCustOutstandingfromdelBilling(CustEntryNo: Integer; AmountLCY: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateCustOutstandingfromrecBilling(CustEntryNo: Integer; AmountLCY: Decimal; OldAmountLCY: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateVendOutstanding(VendEntryNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateVendOutstandingfromdel(VendEntryNo: Integer; AmountLCY: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateVendOutstandingfromrec(VendEntryNo: Integer; AmountLCY: Decimal; OldAmountLCY: Decimal; var IsHandled: Boolean)
    begin
    end;
    // Ton 2022-04-27 --
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        BillingRcptHeader: Record "TPP Billing - Receipt Header";
        VendLedgerEntry: Record "Vendor Ledger Entry";
        FKFunc: Codeunit "FK Func";
}
