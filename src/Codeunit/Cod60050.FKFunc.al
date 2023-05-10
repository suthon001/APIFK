/// <summary>
/// Codeunit FK Func (ID 60050).
/// </summary>
codeunit 60050 "FK Func"
{


    local procedure SelectoptionGenLine(pValue: Text): Enum "Gen. Journal Account Type"
    var

        GenLineType: Enum "Gen. Journal Account Type";
    begin
        GenLineType := Enum::"Gen. Journal Account Type".FromInteger(GenLineType.Ordinals.Get(GenLineType.Names.IndexOf(pValue)));
        exit(GenLineType);
    end;

    local procedure SelectoptionSales(pValue: Text): Enum "Sales Line Type"
    var

        SalesLineType: Enum "Sales Line Type";
    begin
        SalesLineType := Enum::"Sales Line Type".FromInteger(SalesLineType.Ordinals.Get(SalesLineType.Names.IndexOf(pValue)));
        exit(SalesLineType);
    end;

    local procedure SelectoptionPurchase(pValue: Text): Enum "Purchase Line Type"
    var

        PurchaseLineType: Enum "Purchase Line Type";
    begin
        PurchaseLineType := Enum::"Purchase Line Type".FromInteger(PurchaseLineType.Ordinals.Get(PurchaseLineType.Names.IndexOf(pValue)));
        exit(PurchaseLineType);
    end;


    procedure ImportItemJournalPositive(pIsManual: Boolean)
    var
        ltItemJournalTemp: Record "Item Journal Line" temporary;
        ltItemJournal: Record "Item Journal Line";
        ltFileName: Text;
    begin
        if InsertToITemJournal(0, ltItemJournalTemp, ltFileName, pIsManual) then begin
            if ltItemJournalTemp.FindSet() then
                repeat
                    ltItemJournal.Init();
                    ltItemJournal.TransferFields(ltItemJournalTemp);
                    ltItemJournal.Insert();
                    InsertLot(ltItemJournal, ltItemJournal."Temp. Lot No.", ltItemJournal."Temp. Expire Date");
                until ltItemJournalTemp.Next() = 0;
            InsertLogTransaction(Database::"Item Journal Line", 'POSITIVE', CurrentDateTime(), 0, '', ltFileName, 0);
        end else
            InsertLogTransaction(Database::"Item Journal Line", 'POSITIVE', CurrentDateTime(), 1, GetLastErrorText(), ltFileName, 0);
    end;


    procedure ImportItemJournalNegative(pIsManual: Boolean)
    var
        ltItemJournalTemp: Record "Item Journal Line" temporary;
        ltItemJournal: Record "Item Journal Line";
        ltFileName: Text;
    begin
        if InsertToITemJournal(1, ltItemJournalTemp, ltFileName, pIsManual) then begin
            if ltItemJournalTemp.FindSet() then
                repeat
                    ltItemJournal.Init();
                    ltItemJournal.TransferFields(ltItemJournalTemp);
                    ltItemJournal.Insert();
                    InsertLot(ltItemJournal, ltItemJournal."Temp. Lot No.", ltItemJournal."Temp. Expire Date");
                until ltItemJournalTemp.Next() = 0;
            InsertLogTransaction(Database::"Item Journal Line", 'NEGATIVE', CurrentDateTime(), 0, '', ltFileName, 0);
        end else
            InsertLogTransaction(Database::"Item Journal Line", 'NEGATIVE', CurrentDateTime(), 1, GetLastErrorText(), ltFileName, 0);

    end;

    procedure ImportItemJournalReclass(pIsManual: Boolean)
    var
        ltItemJournalTemp: Record "Item Journal Line" temporary;
        ltItemJournal: Record "Item Journal Line";
        ltFileName: Text;
    begin
        if InsertToItemJournalReclass(ltItemJournalTemp, ltFileName, pIsManual) then begin
            if ltItemJournalTemp.FindSet() then
                repeat
                    ltItemJournal.Init();
                    ltItemJournal.TransferFields(ltItemJournalTemp);
                    ltItemJournal.Insert();
                    InsertLot(ltItemJournal, ltItemJournal."Temp. Lot No.", ltItemJournal."Temp. Expire Date");
                until ltItemJournalTemp.Next() = 0;
            InsertLogTransaction(Database::"Item Journal Line", 'RECLASS', CurrentDateTime(), 0, '', ltFileName, 0);
        end else
            InsertLogTransaction(Database::"Item Journal Line", 'RECLASS', CurrentDateTime(), 1, GetLastErrorText(), ltFileName, 0);

    end;

    procedure ImportUpdateGRN(pIsManual: Boolean)
    var
        ltPurchaseHeaderTemp: Record "Purchase Header" temporary;
        ltPurchaseLineTemp: Record "Purchase Line" temporary;
        ltPurchaseHeader: Record "Purchase Header";
        ltPurchaseLine: Record "Purchase Line";
        ltFileName: Text;
    begin
        if updateOrder(0, ltPurchaseHeaderTemp, ltPurchaseLineTemp, ltFileName, pIsManual) then begin
            if ltPurchaseHeaderTemp.FindSet() then
                repeat
                    ltPurchaseHeader.GET(ltPurchaseHeaderTemp."Document Type", ltPurchaseHeaderTemp."No.");
                    ltPurchaseHeader.Validate("Posting Date", ltPurchaseHeaderTemp."Posting Date");
                    ltPurchaseHeader."Vendor Invoice No." := ltPurchaseHeaderTemp."Vendor Invoice No.";
                    ltPurchaseHeader."Ref. GR No. Intranet" := ltPurchaseHeaderTemp."Ref. GR No. Intranet";
                    ltPurchaseHeader.Modify();


                    ltPurchaseLineTemp.reset();
                    ltPurchaseLineTemp.SetRange("Document Type", ltPurchaseHeaderTemp."Document Type");
                    ltPurchaseLineTemp.SetRange("Document No.", ltPurchaseHeaderTemp."No.");
                    if ltPurchaseLineTemp.FindSet() then begin
                        repeat
                            ltPurchaseLine.reset();
                            ltPurchaseLine.SetRange("Document Type", ltPurchaseLineTemp."Document Type");
                            ltPurchaseLine.SetRange("Document No.", ltPurchaseLineTemp."Document No.");
                            ltPurchaseLine.SetRange("No.", ltPurchaseLineTemp."No.");
                            ltPurchaseLine.SetRange("Location Code", ltPurchaseLineTemp."Location Code");
                            if ltPurchaseLine.FindFirst() then begin
                                ltPurchaseLine.Validate("Qty. to Receive", ltPurchaseLineTemp.Quantity);
                                ltPurchaseLine.Modify();
                                InsertLotPurchase(ltPurchaseLine, ltPurchaseLine."Temp. Lot No.", ltPurchaseLine."Temp. Expire Date");
                            end;
                        until ltPurchaseLineTemp.Next() = 0;
                    end;

                until ltPurchaseHeaderTemp.Next() = 0;
            InsertLogTransaction(Database::"Purchase Header", 'PURCHASE GRN', CurrentDateTime(), 0, '', ltFileName, 1);
        end else
            InsertLogTransaction(Database::"Purchase Header", 'PURCHASE GRN', CurrentDateTime(), 1, GetLastErrorText(), ltFileName, 1);
    end;

    procedure ImportUpdateReturnShip(pIsManual: Boolean)
    var
        ltPurchaseHeaderTemp: Record "Purchase Header" temporary;
        ltPurchaseLineTemp: Record "Purchase Line" temporary;
        ltPurchaseHeader: Record "Purchase Header";
        ltPurchaseLine: Record "Purchase Line";
        ltFileName: Text;
    begin
        if updateOrder(1, ltPurchaseHeaderTemp, ltPurchaseLineTemp, ltFileName, pIsManual) then begin
            if ltPurchaseHeaderTemp.FindSet() then
                repeat
                    ltPurchaseHeader.GET(ltPurchaseHeaderTemp."Document Type", ltPurchaseHeaderTemp."No.");
                    ltPurchaseHeader.Validate("Posting Date", ltPurchaseHeaderTemp."Posting Date");
                    ltPurchaseHeader."Vendor Cr. Memo No." := ltPurchaseHeaderTemp."Vendor Cr. Memo No.";
                    ltPurchaseHeader."Ref. GR No. Intranet" := ltPurchaseHeaderTemp."Ref. GR No. Intranet";
                    ltPurchaseHeader.Modify();


                    ltPurchaseLineTemp.reset();
                    ltPurchaseLineTemp.SetRange("Document Type", ltPurchaseHeaderTemp."Document Type");
                    ltPurchaseLineTemp.SetRange("Document No.", ltPurchaseHeaderTemp."No.");
                    if ltPurchaseLineTemp.FindSet() then begin
                        repeat
                            ltPurchaseLine.reset();
                            ltPurchaseLine.SetRange("Document Type", ltPurchaseLineTemp."Document Type");
                            ltPurchaseLine.SetRange("Document No.", ltPurchaseLineTemp."Document No.");
                            ltPurchaseLine.SetRange("No.", ltPurchaseLineTemp."No.");
                            ltPurchaseLine.SetRange("Location Code", ltPurchaseLineTemp."Location Code");
                            if ltPurchaseLine.FindFirst() then begin
                                ltPurchaseLine.Validate("Return Qty. to Ship", ltPurchaseLineTemp.Quantity);
                                ltPurchaseLine.Modify();
                                InsertLotPurchase(ltPurchaseLine, ltPurchaseLine."Temp. Lot No.", ltPurchaseLine."Temp. Expire Date");
                            end;
                        until ltPurchaseLineTemp.Next() = 0;
                    end;

                until ltPurchaseHeaderTemp.Next() = 0;
            InsertLogTransaction(Database::"Purchase Header", 'RETURN SHIP', CurrentDateTime(), 0, '', ltFileName, 1);
        end else
            InsertLogTransaction(Database::"Purchase Header", 'RETURN SHIP', CurrentDateTime(), 1, GetLastErrorText(), ltFileName, 1);
    end;

    local procedure InsertLotPurchase(pPurchaseLine: Record "Purchase Line"; pLotNo: code[50]; pExpireDate: Date)
    var
        ltItem: Record Item;
        TempReservEntry: Record "Reservation Entry" temporary;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ReservStatus: Enum "Reservation Status";
    begin
        if ltItem.GET(pPurchaseLine."No.") then begin
            IF ltItem."Item Tracking Code" <> '' then
                if pLotNo <> '' then begin
                    TempReservEntry.Init();
                    TempReservEntry."Entry No." := GetLastReserveEntry();
                    TempReservEntry."Lot No." := pLotNo;
                    TempReservEntry.Quantity := pPurchaseLine.Quantity;
                    if pExpireDate <> 0D then
                        TempReservEntry."Expiration Date" := pExpireDate
                    else
                        TempReservEntry."Expiration Date" := Today();
                    TempReservEntry.Insert();

                    CreateReservEntry.SetDates(0D, TempReservEntry."Expiration Date");
                    CreateReservEntry.CreateReservEntryFor(
                      Database::"Purchase Line", pPurchaseLine."Document Type".AsInteger(),
                      pPurchaseLine."Document No.", '', 0, pPurchaseLine."Line No.", pPurchaseLine."Qty. per Unit of Measure",
                      TempReservEntry.Quantity, TempReservEntry.Quantity * pPurchaseLine."Qty. per Unit of Measure", TempReservEntry);
                    CreateReservEntry.CreateEntry(
                      pPurchaseLine."No.", pPurchaseLine."Variant Code", pPurchaseLine."Location Code", '', pPurchaseLine."Expected Receipt Date", 0D, 0, ReservStatus::Surplus);
                end;

        end;
    end;

    [TryFunction]
    local procedure updateOrder(ImportType: Option GRN,Return; var pPurchaseHeader: Record "Purchase Header" temporary; var pPurchaseLine: Record "Purchase Line" temporary; var pFileName: Text[100]; pIsManual: Boolean)
    var
        CSVBuffer, TempCSVBuffer : Record "CSV Buffer" temporary;
        ltPurchaseHeader: Record "Purchase Header" temporary;
        ltPurchaseLine: Record "Purchase Line" temporary;
        ltPurchaseHeaderUpdate: Record "Purchase Header";
        InterfaceSetup: Record "FK Interface Setup";
        ltItem: Record Item;
        ltLocation: Record location;
        ltUnitOfMeasure: Record "Unit of Measure";
        ltVatprod: record "VAT Product Posting Group";
        UploadResult, CSVFileName : text;
        CSVInStrem: InStream;
        LastField: Integer;
        ltDate: Date;
        ltDicimal: Decimal;
        ltInteger: Integer;
        ltCheckAlready: Boolean;
        ltPurchaseDocType: Enum "Purchase Document Type";
    begin
        if not pIsManual then begin
            if ImportType = ImportType::GRN then begin
                InterfaceSetup.TestField("Purchase GRN Path");
                InterfaceSetup.TestField("Purch. GRN Succ. Path");
                InterfaceSetup.TestField("Purch. GRN Error Path");
            end else begin
                InterfaceSetup.TestField("Return to ship Path");
                InterfaceSetup.TestField("Return to ship Succ. Path");
                InterfaceSetup.TestField("Return to ship Err Path");
            end;
        end;
        if UploadIntoStream('File Name', '', '', CSVFileName, CSVInStrem) then begin
            pFileName := CSVFileName;
            CSVBuffer.reset();
            CSVBuffer.DeleteAll();
            CSVBuffer.LoadDataFromStream(CSVInStrem, ',');
            CSVBuffer.SetFilter("Line No.", '>%1', 1);
            if CSVBuffer.FindSet() then begin
                repeat
                    case CSVBuffer."Field No." of
                        1:
                            begin
                                TempCSVBuffer.Copy(CSVBuffer, true);
                                TempCSVBuffer.SetCurrentKey("Line No.", "Field No.");
                                if TempCSVBuffer.FindLast() then
                                    LastField := TempCSVBuffer."Field No.";

                                if ImportType = ImportType::GRN then
                                    ltPurchaseDocType := ltPurchaseDocType::Order
                                else
                                    ltPurchaseDocType := ltPurchaseDocType::"Return Order";
                                ltPurchaseHeaderUpdate.get(ltPurchaseDocType, CSVBuffer.Value);
                                if not ltPurchaseHeader.GET(ltPurchaseDocType, CSVBuffer.Value) then begin
                                    ltPurchaseHeader.Init();
                                    ltPurchaseHeader."Document Type" := ltPurchaseDocType;
                                    ltPurchaseHeader."No." := CSVBuffer.Value;
                                    ltPurchaseHeader.Insert(true);
                                    ltPurchaseHeader."Buy-from Vendor No." := ltPurchaseHeaderUpdate."Buy-from Vendor No.";
                                end else
                                    ltCheckAlready := true;
                            end;
                        2:
                            begin
                                if not ltCheckAlready then
                                    if Evaluate(ltDate, CSVBuffer.Value) then
                                        ltPurchaseHeader.Validate("Posting Date", ltDate);
                            end;

                        3:
                            begin
                                if not ltCheckAlready then begin
                                    if ImportType = ImportType::GRN then
                                        ltPurchaseHeader.Validate("Vendor Invoice No.", CSVBuffer.Value)
                                    else
                                        ltPurchaseHeader.Validate("Vendor Cr. Memo No.", CSVBuffer.Value);
                                end;
                            end;
                        4:
                            begin
                                if not ltCheckAlready then
                                    ltPurchaseHeader.Validate("Ref. GR No. Intranet", CSVBuffer.Value);
                                ltPurchaseHeader.Modify();
                            end;


                        5:
                            begin
                                ltInteger := ltInteger + 1;
                                ltPurchaseLine.init();
                                ltPurchaseLine."Document Type" := ltPurchaseHeader."Document Type";
                                ltPurchaseLine."Document No." := ltPurchaseHeader."No.";
                                ltPurchaseLine."Line No." := ltInteger;
                                ltPurchaseLine."Buy-from Vendor No." := ltPurchaseHeader."Buy-from Vendor No.";
                                ltPurchaseLine."Pay-to Vendor No." := ltPurchaseHeader."Pay-to Vendor No.";
                                ltPurchaseLine.Insert();
                                ltPurchaseLine.Type := SelectoptionPurchase(CSVBuffer.Value);
                                ltItem.GET(CSVBuffer.Value);
                                ltPurchaseLine."No." := CSVBuffer.Value;

                            end;
                        6:
                            begin
                                if CSVBuffer.Value <> '' then
                                    ltLocation.get(CSVBuffer.Value);
                                ltPurchaseLine."Location Code" := CSVBuffer.Value;

                            end;
                        7:
                            begin
                                if Evaluate(ltDicimal, CSVBuffer.Value) then
                                    ltPurchaseLine.Quantity := ltDicimal;

                            end;
                        8:
                            begin
                                ltPurchaseLine."Temp. Lot No." := CSVBuffer.Value;

                            end;
                        9:
                            begin
                                if Evaluate(ltDate, CSVBuffer.Value) then
                                    ltPurchaseLine."Temp. Expire Date" := ltDate;

                            end;
                    end;

                    if CSVBuffer."Field No." = LastField then begin
                        ltCheckAlready := false;
                        ltPurchaseLine.Modify();
                    end;

                until CSVBuffer.Next() = 0;
                pPurchaseHeader.copy(ltPurchaseHeader, true);
                pPurchaseLine.copy(ltPurchaseLine, true);
            end;
        end;
    end;

    procedure ImportPO(pIsManual: Boolean)
    var
        ltPurchaseHeaderTemp: Record "Purchase Header" temporary;
        ltPurchaseLineTemp: Record "Purchase Line" temporary;
        ltPurchaseHeader: Record "Purchase Header";
        ltPurchaseLine: Record "Purchase Line";
        ltFileName: Text;
    begin
        if InsertToPurchase(0, ltPurchaseHeaderTemp, ltPurchaseLineTemp, ltFileName, pIsManual) then begin
            if ltPurchaseHeaderTemp.FindSet() then
                repeat
                    ltPurchaseHeader.Init();
                    ltPurchaseHeader.TransferFields(ltPurchaseHeaderTemp);
                    ltPurchaseHeader.Insert();

                    ltPurchaseLineTemp.reset();
                    ltPurchaseLineTemp.SetRange("Document Type", ltPurchaseHeaderTemp."Document Type");
                    ltPurchaseLineTemp.SetRange("Document No.", ltPurchaseHeaderTemp."No.");
                    if ltPurchaseLineTemp.FindSet() then begin
                        repeat
                            ltPurchaseLine.Init();
                            ltPurchaseLine.Copy(ltPurchaseLineTemp);
                            ltPurchaseLine.Insert();
                            ltPurchaseLine.Validate(Quantity, ltPurchaseLineTemp.Quantity);
                            if ltPurchaseLineTemp."Location Code" <> '' then
                                ltPurchaseLine.Validate("Location Code", ltPurchaseLineTemp."Location Code");
                            if ltPurchaseLineTemp."Unit of Measure Code" <> '' then
                                ltPurchaseLine.Validate("Unit of Measure Code", ltPurchaseLineTemp."Unit of Measure Code");
                            ltPurchaseLine.Validate("Direct Unit Cost", ltPurchaseLineTemp."Direct Unit Cost");
                            if ltPurchaseLineTemp."Line Discount Amount" <> 0 then
                                ltPurchaseLine.Validate("Line Discount Amount", ltPurchaseLineTemp."Line Discount Amount");
                            if ltPurchaseLineTemp."VAT Prod. Posting Group" <> '' then
                                ltPurchaseLine.Validate("VAT Prod. Posting Group", ltPurchaseLineTemp."VAT Prod. Posting Group");
                            ltPurchaseLine.Modify();
                        until ltPurchaseLineTemp.Next() = 0;
                    end;
                    ltPurchaseHeader.Status := ltPurchaseHeader.Status::Released;
                    ltPurchaseHeader.Modify();
                until ltPurchaseHeaderTemp.Next() = 0;
            InsertLogTransaction(Database::"Purchase Header", 'PURCHASE ORDER', CurrentDateTime(), 0, '', ltFileName, 0);
        end else
            InsertLogTransaction(Database::"Purchase Header", 'PURCHASE ORDER', CurrentDateTime(), 1, GetLastErrorText(), ltFileName, 0);
    end;

    procedure ImportReturnOrder(pIsManual: Boolean)
    var
        ltPurchaseHeaderTemp: Record "Purchase Header" temporary;
        ltPurchaseLineTemp: Record "Purchase Line" temporary;
        ltPurchaseHeader: Record "Purchase Header";
        ltPurchaseLine: Record "Purchase Line";
        ltFileName: Text;
    begin
        if InsertToPurchase(1, ltPurchaseHeaderTemp, ltPurchaseLineTemp, ltFileName, pIsManual) then begin
            if ltPurchaseHeaderTemp.FindSet() then
                repeat
                    ltPurchaseHeader.Init();
                    ltPurchaseHeader.TransferFields(ltPurchaseHeaderTemp);
                    ltPurchaseHeader.Insert();

                    ltPurchaseLineTemp.reset();
                    ltPurchaseLineTemp.SetRange("Document Type", ltPurchaseHeaderTemp."Document Type");
                    ltPurchaseLineTemp.SetRange("Document No.", ltPurchaseHeaderTemp."No.");
                    if ltPurchaseLineTemp.FindSet() then begin
                        repeat
                            ltPurchaseLine.Init();
                            ltPurchaseLine.Copy(ltPurchaseLineTemp);
                            ltPurchaseLine.Insert();
                            ltPurchaseLine.Validate(Quantity, ltPurchaseLineTemp.Quantity);
                            if ltPurchaseLineTemp."Location Code" <> '' then
                                ltPurchaseLine.Validate("Location Code", ltPurchaseLineTemp."Location Code");
                            if ltPurchaseLineTemp."Unit of Measure Code" <> '' then
                                ltPurchaseLine.Validate("Unit of Measure Code", ltPurchaseLineTemp."Unit of Measure Code");
                            ltPurchaseLine.Validate("Direct Unit Cost", ltPurchaseLineTemp."Direct Unit Cost");
                            if ltPurchaseLineTemp."Line Discount Amount" <> 0 then
                                ltPurchaseLine.Validate("Line Discount Amount", ltPurchaseLineTemp."Line Discount Amount");
                            if ltPurchaseLineTemp."VAT Prod. Posting Group" <> '' then
                                ltPurchaseLine.Validate("VAT Prod. Posting Group", ltPurchaseLineTemp."VAT Prod. Posting Group");
                            ltPurchaseLine.Modify();
                        until ltPurchaseLineTemp.Next() = 0;
                    end;
                    ltPurchaseHeader.Status := ltPurchaseHeader.Status::Released;
                    ltPurchaseHeader.Modify();
                until ltPurchaseHeaderTemp.Next() = 0;
            InsertLogTransaction(Database::"Purchase Header", 'RETURN ORDER', CurrentDateTime(), 0, '', ltFileName, 0);
        end else
            InsertLogTransaction(Database::"Purchase Header", 'RETURN ORDER', CurrentDateTime(), 1, GetLastErrorText(), ltFileName, 0);
    end;


    [TryFunction]
    local procedure InsertToPurchase(ImportType: Option PO,Return; var pPurchaseHeader: Record "Purchase Header" temporary; var pPurchaseLine: Record "Purchase Line" temporary; var pFileName: Text[100]; pIsManual: Boolean)
    var
        InterfaceSetup: Record "FK Interface Setup";
        CSVBuffer, TempCSVBuffer : Record "CSV Buffer" temporary;
        ltPurchaseHeader: Record "Purchase Header" temporary;
        ltPurchaseLine: Record "Purchase Line" temporary;
        ltItem: Record Item;
        ltLocation: Record location;
        ltUnitOfMeasure: Record "Unit of Measure";
        ltVatprod: record "VAT Product Posting Group";
        UploadResult, CSVFileName : text;
        CSVInStrem: InStream;
        LastField: Integer;
        ltDate: Date;
        ltDicimal: Decimal;
        ltInteger: Integer;
        ltCheckAlready: Boolean;
        ltPurchaseDocType: Enum "Purchase Document Type";

    begin
        InterfaceSetup.GET();

        if not pIsManual then begin
            if ImportType = ImportType::PO then begin
                InterfaceSetup.TestField("Purchase Order Path");
                InterfaceSetup.TestField("Purchase Order Succ. Path");
                InterfaceSetup.TestField("Purchase Order Error Path");
            end else begin
                InterfaceSetup.TestField("Purchase Return Order Path");
                InterfaceSetup.TestField("Purch. Return Order Succ. Path");
                InterfaceSetup.TestField("Purch. Return Order Error Path");
            end;
        end;
        if UploadIntoStream('File Name', '', '', CSVFileName, CSVInStrem) then begin
            pFileName := CSVFileName;
            CSVBuffer.reset();
            CSVBuffer.DeleteAll();
            CSVBuffer.LoadDataFromStream(CSVInStrem, ',');
            CSVBuffer.SetFilter("Line No.", '>%1', 1);
            if CSVBuffer.FindSet() then begin
                repeat
                    case CSVBuffer."Field No." of
                        1:
                            begin
                                TempCSVBuffer.Copy(CSVBuffer, true);
                                TempCSVBuffer.SetCurrentKey("Line No.", "Field No.");
                                if TempCSVBuffer.FindLast() then
                                    LastField := TempCSVBuffer."Field No.";
                            end;
                        2:
                            begin
                                if ImportType = ImportType::PO then
                                    ltPurchaseDocType := ltPurchaseDocType::Order
                                else
                                    ltPurchaseDocType := ltPurchaseDocType::"Return Order";

                                if not ltPurchaseHeader.GET(ltPurchaseDocType, CSVBuffer.Value) then begin
                                    ltPurchaseHeader.Init();
                                    ltPurchaseHeader."Document Type" := ltPurchaseDocType;
                                    ltPurchaseHeader."No." := CSVBuffer.Value;
                                    ltPurchaseHeader.Insert(true);
                                end else
                                    ltCheckAlready := true;
                            end;

                        3:
                            begin
                                if not ltCheckAlready then
                                    ltPurchaseHeader.Validate("Buy-from Vendor No.", CSVBuffer.Value);
                            end;
                        4:
                            begin
                                if not ltCheckAlready then
                                    ltPurchaseHeader.Validate("Vendor No. Intranet", CSVBuffer.Value);
                            end;
                        5:
                            begin
                                if not ltCheckAlready then
                                    if Evaluate(ltDate, CSVBuffer.Value) then
                                        ltPurchaseHeader.Validate("Order Date", ltDate);
                            end;
                        6:
                            begin
                                if not ltCheckAlready then
                                    if Evaluate(ltDate, CSVBuffer.Value) then
                                        ltPurchaseHeader.Validate("Posting Date", ltDate);
                            end;
                        7:
                            begin
                                if not ltCheckAlready then
                                    if Evaluate(ltDate, CSVBuffer.Value) then
                                        ltPurchaseHeader.Validate("Expected Receipt Date", ltDate);
                            end;
                        8:
                            begin
                                if not ltCheckAlready then
                                    ltPurchaseHeader."Your Reference" := CSVBuffer.Value;
                            end;
                        11:
                            begin
                                if not ltCheckAlready then
                                    if CSVBuffer.Value <> '' then
                                        ltPurchaseHeader.Validate("Shortcut Dimension 1 Code", CSVBuffer.Value);
                            end;

                        12:
                            begin
                                if not ltCheckAlready then begin
                                    if CSVBuffer.Value <> '' then
                                        ltPurchaseHeader.Validate("Shortcut Dimension 2 Code", CSVBuffer.Value);
                                    ltPurchaseHeader.Modify();
                                end;
                            end;

                        13:
                            begin
                                ltPurchaseLine.init();
                                ltPurchaseLine."Document Type" := ltPurchaseHeader."Document Type";
                                ltPurchaseLine."Document No." := ltPurchaseHeader."No.";
                                Evaluate(ltInteger, CSVBuffer.Value);
                                ltPurchaseLine."Line No." := ltInteger;
                                ltPurchaseLine."Buy-from Vendor No." := ltPurchaseHeader."Buy-from Vendor No.";
                                ltPurchaseLine."Pay-to Vendor No." := ltPurchaseHeader."Pay-to Vendor No.";
                                ltPurchaseLine.Insert();

                            end;
                        14:
                            begin

                                ltPurchaseLine.Type := ltPurchaseLine.Type::Item;
                            end;

                        15:
                            begin
                                ltItem.GET(CSVBuffer.Value);
                                ltPurchaseLine."No." := CSVBuffer.Value;
                                ltPurchaseLine.Description := ltItem.Description;
                                ltPurchaseLine."Description 2" := ltItem."Description 2";
                                ltPurchaseLine."Unit of Measure Code" := ltItem."Purch. Unit of Measure";
                            end;
                        16:
                            begin
                                if Evaluate(ltDicimal, CSVBuffer.Value) then
                                    ltPurchaseLine.Quantity := ltDicimal;

                            end;
                        17:
                            begin
                                if CSVBuffer.Value <> '' then
                                    ltUnitOfMeasure.get(CSVBuffer.Value);
                                ltPurchaseLine."Unit of Measure Code" := CSVBuffer.Value;

                            end;
                        18:
                            begin
                                if CSVBuffer.Value <> '' then
                                    ltLocation.get(CSVBuffer.Value);
                                ltPurchaseLine."Location Code" := CSVBuffer.Value;

                            end;
                        19:
                            begin
                                if Evaluate(ltDicimal, CSVBuffer.Value) then
                                    ltPurchaseLine."Direct Unit Cost" := ltDicimal;

                            end;
                        22:
                            begin
                                if Evaluate(ltDicimal, CSVBuffer.Value) then
                                    ltPurchaseLine."Line Discount Amount" := ltDicimal;

                            end;
                        23:
                            begin
                                if CSVBuffer.Value <> '' then
                                    ltVatprod.get(CSVBuffer.Value);
                                ltPurchaseLine."VAT Prod. Posting Group" := CSVBuffer.Value;

                            end;

                    end;

                    if CSVBuffer."Field No." = LastField then begin
                        ltCheckAlready := false;
                        ltPurchaseLine.Modify();
                    end;

                until CSVBuffer.Next() = 0;
                pPurchaseHeader.copy(ltPurchaseHeader, true);
                pPurchaseLine.copy(ltPurchaseLine, true);
            end;
        end;
    end;

    procedure ImportToSalesCreditMemo(pIsManual: Boolean)
    var
        ltSalesHeaderTemp: Record "Sales Header" temporary;
        ltSalesLineTemp: Record "Sales Line" temporary;
        ltSalesHEader: Record "Sales Header";
        ltSalesLine: Record "Sales Line";
        ltFileName: Text;
    begin
        if InsertToSales(1, ltSalesHeaderTemp, ltSalesLineTemp, ltFileName, pIsManual) then begin
            if ltSalesHeaderTemp.FindSet() then
                repeat
                    ltSalesHEader.Init();
                    ltSalesHEader.TransferFields(ltSalesHeaderTemp);
                    ltSalesHEader.Insert();

                    ltSalesLineTemp.reset();
                    ltSalesLineTemp.SetRange("Document Type", ltSalesHeaderTemp."Document Type");
                    ltSalesLineTemp.SetRange("Document No.", ltSalesHeaderTemp."No.");
                    if ltSalesLineTemp.FindSet() then begin
                        repeat
                            ltSalesLine.Init();
                            ltSalesLine.Copy(ltSalesLineTemp);
                            ltSalesLine.Insert();
                            ltSalesLine.Validate(Quantity, ltSalesLineTemp.Quantity);
                            if ltSalesLineTemp."Location Code" <> '' then
                                ltSalesLine.Validate("Location Code", ltSalesLineTemp."Location Code");
                            if ltSalesLineTemp."Unit of Measure Code" <> '' then
                                ltSalesLine.Validate("Unit of Measure Code", ltSalesLineTemp."Unit of Measure Code");
                            ltSalesLine.Validate("Unit Price", ltSalesLineTemp."Unit Price");
                            if ltSalesLineTemp."Line Discount Amount" <> 0 then
                                ltSalesLine.Validate("Line Discount Amount", ltSalesLineTemp."Line Discount Amount");
                            if ltSalesLineTemp."VAT Prod. Posting Group" <> '' then
                                ltSalesLine.Validate("VAT Prod. Posting Group", ltSalesLineTemp."VAT Prod. Posting Group");
                            if ltSalesLineTemp."Inv. Discount Amount" <> 0 then
                                ltSalesLine.Validate("Inv. Discount Amount", ltSalesLineTemp."Inv. Discount Amount");
                            ltSalesLine.Modify();
                        until ltSalesLineTemp.Next() = 0;
                    end;
                    ltSalesHEader.Status := ltSalesHEader.Status::Released;
                    ltSalesHEader.Modify();
                until ltSalesHeaderTemp.Next() = 0;
            InsertLogTransaction(Database::"Sales Header", 'SALES CREDIT', CurrentDateTime(), 0, '', ltFileName, 0);
        end else
            InsertLogTransaction(Database::"Sales Header", 'SALES CREDIT', CurrentDateTime(), 1, GetLastErrorText(), ltFileName, 0);
    end;

    procedure ImportToSalesInvoice(pIsManual: Boolean)
    var
        ltSalesHeaderTemp: Record "Sales Header" temporary;
        ltSalesLineTemp: Record "Sales Line" temporary;
        ltSalesHEader: Record "Sales Header";
        ltSalesLine: Record "Sales Line";
        ltFileName: Text;
    begin
        if InsertToSales(0, ltSalesHeaderTemp, ltSalesLineTemp, ltFileName, pIsManual) then begin
            if ltSalesHeaderTemp.FindSet() then
                repeat
                    ltSalesHEader.Init();
                    ltSalesHEader.TransferFields(ltSalesHeaderTemp);
                    ltSalesHEader.Insert();

                    ltSalesLineTemp.reset();
                    ltSalesLineTemp.SetRange("Document Type", ltSalesHeaderTemp."Document Type");
                    ltSalesLineTemp.SetRange("Document No.", ltSalesHeaderTemp."No.");
                    if ltSalesLineTemp.FindSet() then begin
                        repeat
                            ltSalesLine.Init();
                            ltSalesLine.Copy(ltSalesLineTemp);
                            ltSalesLine.Insert();
                            ltSalesLine.Validate(Quantity, ltSalesLineTemp.Quantity);
                            if ltSalesLineTemp."Location Code" <> '' then
                                ltSalesLine.Validate("Location Code", ltSalesLineTemp."Location Code");
                            if ltSalesLineTemp."Unit of Measure Code" <> '' then
                                ltSalesLine.Validate("Unit of Measure Code", ltSalesLineTemp."Unit of Measure Code");
                            ltSalesLine.Validate("Unit Price", ltSalesLineTemp."Unit Price");
                            if ltSalesLineTemp."Line Discount Amount" <> 0 then
                                ltSalesLine.Validate("Line Discount Amount", ltSalesLineTemp."Line Discount Amount");
                            if ltSalesLineTemp."VAT Prod. Posting Group" <> '' then
                                ltSalesLine.Validate("VAT Prod. Posting Group", ltSalesLineTemp."VAT Prod. Posting Group");
                            if ltSalesLineTemp."Inv. Discount Amount" <> 0 then
                                ltSalesLine.Validate("Inv. Discount Amount", ltSalesLineTemp."Inv. Discount Amount");
                            ltSalesLine.Modify();
                        until ltSalesLineTemp.Next() = 0;
                    end;
                    ltSalesHEader.Status := ltSalesHEader.Status::Released;
                    ltSalesHEader.Modify();
                until ltSalesHeaderTemp.Next() = 0;
            InsertLogTransaction(Database::"Sales Header", 'SALES INVOICE', CurrentDateTime(), 0, '', ltFileName, 0);
        end else
            InsertLogTransaction(Database::"Sales Header", 'SALES INVOICE', CurrentDateTime(), 1, GetLastErrorText(), ltFileName, 0);
    end;


    [TryFunction]
    local procedure InsertToSales(ImportType: Option Invoice,Credit; var pSalesHeader: Record "Sales Header" temporary; var pSalesLine: Record "Sales Line" temporary; var pFileName: Text[100]; pIsManual: Boolean)
    var
        CSVBuffer, TempCSVBuffer : Record "CSV Buffer" temporary;
        ltSalesHeaderTemp: Record "Sales Header" temporary;
        ltSalesLineTemp: Record "Sales Line" temporary;
        ltItem: Record Item;
        ltLocation: Record location;
        InterfaceSetup: Record "FK Interface Setup";
        ltUnitOfMeasure: Record "Unit of Measure";
        ltVatprod: record "VAT Product Posting Group";
        UploadResult, CSVFileName : text;
        CSVInStrem: InStream;
        LastField: Integer;
        ltDate: Date;
        ltDicimal: Decimal;
        ltInteger: Integer;
        ltCheckAlready: Boolean;
        ltSalesDocType: Enum "Sales Document Type";
    begin
        if not pIsManual then begin
            if ImportType = ImportType::Invoice then begin
                InterfaceSetup.TestField("Sales Invoice Path");
                InterfaceSetup.TestField("Sales Invoice Succ. Path");
                InterfaceSetup.TestField("Sales Invoice Err Path");
            end else begin
                InterfaceSetup.TestField("Sales Credit Path");
                InterfaceSetup.TestField("Sales Credit Succ. Path");
                InterfaceSetup.TestField("Sales Credit Err Path");
            end;
        end;
        if UploadIntoStream('File Name', '', '', CSVFileName, CSVInStrem) then begin
            pFileName := CSVFileName;
            CSVBuffer.reset();
            CSVBuffer.DeleteAll();
            CSVBuffer.LoadDataFromStream(CSVInStrem, ',');
            CSVBuffer.SetFilter("Line No.", '>%1', 1);
            if CSVBuffer.FindSet() then begin
                repeat
                    case CSVBuffer."Field No." of
                        1:
                            begin
                                TempCSVBuffer.Copy(CSVBuffer, true);
                                TempCSVBuffer.SetCurrentKey("Line No.", "Field No.");
                                if TempCSVBuffer.FindLast() then
                                    LastField := TempCSVBuffer."Field No.";
                            end;
                        2:
                            begin
                                if ImportType = ImportType::Invoice then
                                    ltSalesDocType := ltSalesDocType::Invoice
                                else
                                    ltSalesDocType := ltSalesDocType::"Credit Memo";

                                if not ltSalesHeaderTemp.GET(ltSalesDocType, CSVBuffer.Value) then begin
                                    ltSalesHeaderTemp.Init();
                                    ltSalesHeaderTemp."Document Type" := ltSalesDocType;
                                    ltSalesHeaderTemp."No." := CSVBuffer.Value;
                                    ltSalesHeaderTemp.Insert(true);
                                end else
                                    ltCheckAlready := true;
                            end;

                        3:
                            begin
                                if not ltCheckAlready then
                                    ltSalesHeaderTemp.Validate("Sell-to Customer No.", CSVBuffer.Value);
                            end;
                        6:
                            begin
                                if not ltCheckAlready then
                                    ltSalesHeaderTemp.Validate("Ship-to Code", CSVBuffer.Value);
                            end;


                        7:
                            begin
                                if not ltCheckAlready then
                                    ltSalesHeaderTemp.Validate("Ship-to Name", CSVBuffer.Value);
                            end;
                        8:
                            begin
                                if not ltCheckAlready then
                                    ltSalesHeaderTemp.Validate("Ship-to address", CSVBuffer.Value);
                            end;
                        9:
                            begin
                                if not ltCheckAlready then
                                    ltSalesHeaderTemp.Validate("Ship-to address 2", CSVBuffer.Value);
                            end;
                        10:
                            begin
                                if not ltCheckAlready then
                                    ltSalesHeaderTemp.Validate("Ship-to City", CSVBuffer.Value);
                            end;

                        11:
                            begin
                                if not ltCheckAlready then
                                    ltSalesHeaderTemp.Validate("Ship-to Post Code", CSVBuffer.Value);
                            end;

                        12:
                            begin
                                if not ltCheckAlready then
                                    if Evaluate(ltDate, CSVBuffer.Value) then
                                        ltSalesHeaderTemp.Validate("posting Date", ltDate);
                            end;

                        13:
                            begin
                                if not ltCheckAlready then
                                    ltSalesHeaderTemp.Validate("Payment Method Code", CSVBuffer.Value);
                            end;
                        14:
                            begin
                                if not ltCheckAlready then
                                    ltSalesHeaderTemp.Validate("Your Reference", CSVBuffer.Value);
                            end;

                        15:
                            begin
                                if not ltCheckAlready then
                                    ltSalesHeaderTemp.Validate("External Document No.", CSVBuffer.Value);
                            end;


                        16:
                            begin
                                ltSalesLineTemp.init();
                                ltSalesLineTemp."Document Type" := ltSalesHeaderTemp."Document Type";
                                ltSalesLineTemp."Document No." := ltSalesHeaderTemp."No.";
                                Evaluate(ltInteger, CSVBuffer.Value);
                                ltSalesLineTemp."Line No." := ltInteger;
                                ltSalesLineTemp."Sell-to Customer No." := ltSalesHeaderTemp."Sell-to Customer No.";
                                ltSalesLineTemp."Bill-to Customer No." := ltSalesHeaderTemp."Bill-to Customer No.";
                                ltSalesLineTemp.Insert();

                            end;
                        17:
                            begin

                                ltSalesLineTemp.Type := SelectoptionSales(CSVBuffer.Value);
                            end;

                        18:
                            begin
                                ltItem.GET(CSVBuffer.Value);
                                ltSalesLineTemp."No." := CSVBuffer.Value;
                                ltSalesLineTemp.Description := ltItem.Description;
                                ltSalesLineTemp."Description 2" := ltItem."Description 2";
                                ltSalesLineTemp."Unit of Measure Code" := ltItem."Sales Unit of Measure";
                            end;
                        19:
                            begin

                                ltSalesLineTemp.Description := CSVBuffer.Value;
                            end;
                        20:
                            begin
                                if Evaluate(ltDicimal, CSVBuffer.Value) then
                                    ltSalesLineTemp.Quantity := ltDicimal;

                            end;
                        21:
                            begin
                                if CSVBuffer.Value <> '' then
                                    ltUnitOfMeasure.get(CSVBuffer.Value);
                                ltSalesLineTemp."Unit of Measure Code" := CSVBuffer.Value;

                            end;
                        22:
                            begin
                                if CSVBuffer.Value <> '' then
                                    ltLocation.get(CSVBuffer.Value);
                                ltSalesLineTemp."Location Code" := CSVBuffer.Value;

                            end;
                        23:
                            begin
                                if Evaluate(ltDicimal, CSVBuffer.Value) then
                                    ltSalesLineTemp."Unit Price" := ltDicimal;

                            end;

                        26:
                            begin
                                if CSVBuffer.Value <> '' then
                                    ltVatprod.get(CSVBuffer.Value);
                                ltSalesLineTemp."VAT Prod. Posting Group" := CSVBuffer.Value;

                            end;
                        27:
                            begin
                                if Evaluate(ltDicimal, CSVBuffer.Value) then
                                    ltSalesLineTemp."Line Discount Amount" := ltDicimal;

                            end;
                        28:
                            begin
                                if Evaluate(ltDicimal, CSVBuffer.Value) then
                                    ltSalesLineTemp."Inv. Discount Amount" := ltDicimal;

                            end;

                    end;

                    if CSVBuffer."Field No." = LastField then begin
                        ltCheckAlready := false;
                        ltSalesLineTemp.Modify();
                    end;

                until CSVBuffer.Next() = 0;
                pSalesHeader.copy(ltSalesHeaderTemp, true);
                pSalesLine.copy(ltSalesLineTemp, true);
            end;
        end;
    end;

    procedure ImportToCashReceipt(pIsManual: Boolean)
    var
        ltGenJournalTemp: Record "Gen. Journal Line" temporary;
        ltGenJournalLine: Record "Gen. Journal Line";
        ltFileName: Text;
    begin
        if InsertToICashReceipt(ltGenJournalTemp, ltFileName, pIsManual) then begin
            if ltGenJournalTemp.FindSet() then
                repeat
                    ltGenJournalLine.Init();
                    ltGenJournalLine.TransferFields(ltGenJournalTemp);
                    ltGenJournalLine.Insert();
                until ltGenJournalTemp.Next() = 0;
            InsertLogTransaction(Database::"Gen. Journal Line", 'CASH RECEIPT', CurrentDateTime(), 0, '', ltFileName, 0);
        end else
            InsertLogTransaction(Database::"Gen. Journal Line", 'CASH RECEIPT', CurrentDateTime(), 1, GetLastErrorText(), ltFileName, 0);
    end;

    [TryFunction]
    local procedure InsertToICashReceipt(var pGenJournalLine: Record "Gen. Journal Line" temporary; var pFileName: Text[100]; pIsManual: Boolean)
    var
        GenJournalLIne: Record "Gen. Journal Line" temporary;
        CSVBuffer, TempCSVBuffer : Record "CSV Buffer" temporary;
        InterfaceSetup: Record "FK Interface Setup";
        GenJournalTemplate: Record "Gen. Journal Template";
        UploadResult, CSVFileName : text;
        CSVInStrem: InStream;
        ltLineNo: Integer;
        ltDate: Date;
        ltDicimal: Decimal;
        TotalRec, LastField : Integer;
        ltTemplateName, ltBatchName : code[30];
    begin
        InterfaceSetup.GET();

        InterfaceSetup.TestField("Cash Receipt Temp. Name");
        InterfaceSetup.TestField("Cash Receipt Batch Name");
        ltTemplateName := InterfaceSetup."Cash Receipt Temp. Name";
        ltBatchName := InterfaceSetup."Cash Receipt Batch Name";
        if not pIsManual then begin
            InterfaceSetup.TestField("Cash Receipt Path");
            InterfaceSetup.TestField("Cash Receipt Success Path");
            InterfaceSetup.TestField("Cash Receipt Error Path");
        end;
        GenJournalTemplate.GET(ltTemplateName);
        ltLineNo := GetLastLineItemJournal(ltTemplateName, ltBatchName);
        if UploadIntoStream('File Name', '', '', CSVFileName, CSVInStrem) then begin
            pFileName := CSVFileName;
            CSVBuffer.reset();
            CSVBuffer.DeleteAll();
            CSVBuffer.LoadDataFromStream(CSVInStrem, ',');
            CSVBuffer.SetFilter("Line No.", '>%1', 1);
            if CSVBuffer.FindSet() then begin
                repeat
                    case CSVBuffer."Field No." of
                        1:
                            begin
                                TempCSVBuffer.Copy(CSVBuffer, true);
                                TempCSVBuffer.SetCurrentKey("Line No.", "Field No.");
                                if TempCSVBuffer.FindLast() then
                                    LastField := TempCSVBuffer."Field No.";

                                ltLineNo := ltLineNo + 10000;
                                GenJournalLIne.Init();
                                GenJournalLIne."Journal Template Name" := ltTemplateName;
                                GenJournalLIne."Journal Batch Name" := ltBatchName;
                                GenJournalLIne."Line No." := ltLineNo;
                                GenJournalLIne."Source Code" := GenJournalTemplate."Source Code";
                                GenJournalLIne.Insert(true);
                                TotalRec := TotalRec + 1;
                            end;


                        4:
                            begin
                                if Evaluate(ltDate, CSVBuffer.Value) then
                                    GenJournalLIne.Validate("Posting Date", ltDate);
                            end;
                        5:
                            begin
                                if Evaluate(ltDate, CSVBuffer.Value) then
                                    GenJournalLIne.Validate("Document Date", ltDate);
                            end;
                        6:
                            begin
                                GenJournalLIne."Document Type" := GenJournalLIne."Document Type"::Payment;
                            end;
                        7:
                            GenJournalLIne.Validate("Document No.", CSVBuffer.Value);
                        8:
                            begin
                                GenJournalLIne.validate("External Document No.", CSVBuffer.Value);
                            end;
                        9:
                            begin

                                GenJournalLIne.validate("Account Type", SelectoptionGenLine(CSVBuffer.Value));
                            end;
                        10:
                            begin
                                GenJournalLIne.Validate("Account No.", CSVBuffer.Value);
                            end;
                        11:
                            begin
                                GenJournalLIne.Validate("Description", CSVBuffer.Value);
                            end;
                        12:
                            if CSVBuffer.Value <> '' then
                                GenJournalLIne.Validate("Currency Code", CSVBuffer.Value);
                        13:
                            if Evaluate(ltDicimal, CSVBuffer.Value) then
                                GenJournalLIne.Validate("Amount", ltDicimal);

                        15:
                            begin
                                if CSVBuffer.Value <> '' then begin
                                    GenJournalLIne."Applies-to Doc. Type" := GenJournalLIne."Applies-to Doc. Type"::Invoice;
                                    GenJournalLIne.Validate("Applies-to Doc. No.", CSVBuffer.Value);
                                end;
                            end;
                    end;
                    if CSVBuffer."Field No." = LastField then
                        GenJournalLIne.Modify();


                until CSVBuffer.Next() = 0;
                pGenJournalLine.copy(GenJournalLIne, true);
            end;
        end;
    end;

    [TryFunction]
    local procedure InsertToItemJournal(ImportType: Option Positive,Negative; var pItemJournalTemp: Record "Item Journal Line" temporary; var pFileName: Text[100]; pIsManual: Boolean)
    var
        ItemJournal: Record "Item Journal Line" temporary;
        CSVBuffer, TempCSVBuffer : Record "CSV Buffer" temporary;
        InterfaceSetup: Record "FK Interface Setup";
        ITemJournalTemplate: Record "Item Journal Template";
        UploadResult, CSVFileName : text;
        CSVInStrem: InStream;
        ltLineNo: Integer;
        ltDate: Date;
        ltDicimal: Decimal;
        TotalRec, LastField : Integer;
        ltTemplateName, ltBatchName : code[30];
    begin
        InterfaceSetup.GET();
        if ImportType = ImportType::Positive then begin
            InterfaceSetup.TestField("Item Journal Temp. Name (pos.)");
            InterfaceSetup.TestField("Item Journal Batch Name (Pos.)");
            ltTemplateName := InterfaceSetup."Item Journal Temp. Name (pos.)";
            ltBatchName := InterfaceSetup."Item Journal Batch Name (Pos.)";
            if not pIsManual then begin
                InterfaceSetup.TestField("Item Journal Positive Path");
                InterfaceSetup.TestField("Item Journal Pos. Success Path");
                InterfaceSetup.TestField("Item Journal Pos. Error Path");
            end;
        end;
        if ImportType = ImportType::Negative then begin
            InterfaceSetup.TestField("Item Journal Temp. Name (Neg.)");
            InterfaceSetup.TestField("Item Journal Batch Name (Neg.)");
            ltTemplateName := InterfaceSetup."Item Journal Temp. Name (Neg.)";
            ltBatchName := InterfaceSetup."Item Journal Batch Name (Neg.)";
            if not pIsManual then begin
                InterfaceSetup.TestField("Item Journal Nagative Path");
                InterfaceSetup.TestField("Item Journal Neg. Success Path");
                InterfaceSetup.TestField("Item Journal Neg. Error Path");
            end;

        end;

        ITemJournalTemplate.GET(ltTemplateName);
        ltLineNo := GetLastLineItemJournal(ltTemplateName, ltBatchName);
        if UploadIntoStream('File Name', '', '', CSVFileName, CSVInStrem) then begin
            pFileName := CSVFileName;
            CSVBuffer.reset();
            CSVBuffer.DeleteAll();
            CSVBuffer.LoadDataFromStream(CSVInStrem, ',');
            CSVBuffer.SetFilter("Line No.", '>%1', 1);
            if CSVBuffer.FindSet() then begin
                repeat
                    case CSVBuffer."Field No." of
                        1:
                            begin
                                TempCSVBuffer.Copy(CSVBuffer, true);
                                TempCSVBuffer.SetCurrentKey("Line No.", "Field No.");
                                if TempCSVBuffer.FindLast() then
                                    LastField := TempCSVBuffer."Field No.";

                                ltLineNo := ltLineNo + 10000;
                                ItemJournal.Init();
                                ItemJournal."Journal Template Name" := ltTemplateName;
                                ItemJournal."Journal Batch Name" := ltBatchName;
                                ItemJournal."Line No." := ltLineNo;
                                ItemJournal."Source Code" := ITemJournalTemplate."Source Code";
                                if ImportType = ImportType::Positive then
                                    ItemJournal."Entry Type" := ItemJournal."Entry Type"::"Positive Adjmt.";
                                if ImportType = ImportType::Negative then
                                    ItemJournal."Entry Type" := ItemJournal."Entry Type"::"Negative Adjmt.";
                                ItemJournal.Insert(true);
                                if Evaluate(ltDate, CSVBuffer.Value) then
                                    ItemJournal.Validate("Posting Date", ltDate);
                                TotalRec := TotalRec + 1;
                            end;
                        3:
                            ItemJournal.Validate("Document No.", CSVBuffer.Value);

                        4:
                            ItemJournal.Validate("Item No.", CSVBuffer.Value);
                        5:
                            ItemJournal.Validate("Location Code", CSVBuffer.Value);
                        6:
                            begin
                                if Evaluate(ltDicimal, CSVBuffer.Value) then
                                    ItemJournal.Validate(Quantity, ltDicimal);
                            end;
                        7:
                            ItemJournal."Temp. Lot No." := CSVBuffer.Value;
                        8:
                            begin
                                if Evaluate(ltDate, CSVBuffer.Value) then
                                    ItemJournal."Temp. Expire Date" := ltDate
                            end;
                        9:
                            ItemJournal.Validate("Reason Code", CSVBuffer.Value);

                        10:
                            ItemJournal.Validate("Gen. Bus. Posting Group", CSVBuffer.Value);
                    end;
                    if CSVBuffer."Field No." = LastField then
                        ItemJournal.Modify();


                until CSVBuffer.Next() = 0;
                pItemJournalTemp.copy(ItemJournal, true);
            end;
        end;
    end;

    [TryFunction]
    local procedure InsertToItemJournalReclass(var pItemJournalTemp: Record "Item Journal Line" temporary; var pFileName: Text[100]; pIsManual: Boolean)
    var
        ItemJournal: Record "Item Journal Line" temporary;
        CSVBuffer, TempCSVBuffer : Record "CSV Buffer" temporary;
        InterfaceSetup: Record "FK Interface Setup";
        ITemJournalTemplate: Record "Item Journal Template";
        UploadResult, CSVFileName : text;
        CSVInStrem: InStream;
        ltLineNo: Integer;
        ltDate: Date;
        ltDicimal: Decimal;

        TotalRec, LastField : Integer;
        ltTemplateName, ltBatchName : code[30];
    begin
        InterfaceSetup.GET();

        InterfaceSetup.TestField("Item Journal Temp. Name (Rec.)");
        InterfaceSetup.TestField("Item Journal Batch Name (Rec.)");
        if not pIsManual then begin
            InterfaceSetup.TestField("Item Journal Reclass Path");
            InterfaceSetup.TestField("Item Journal Rec. Success Path");
            InterfaceSetup.TestField("Item Journal Rec. Error Path");
        end;
        ltTemplateName := InterfaceSetup."Item Journal Temp. Name (Rec.)";
        ltBatchName := InterfaceSetup."Item Journal Batch Name (Rec.)";
        ITemJournalTemplate.GET(ltTemplateName);
        ltLineNo := GetLastLineItemJournal(ltTemplateName, ltBatchName);
        if UploadIntoStream('File Name', '', '', CSVFileName, CSVInStrem) then begin
            pFileName := CSVFileName;
            CSVBuffer.reset();
            CSVBuffer.DeleteAll();
            CSVBuffer.LoadDataFromStream(CSVInStrem, ',');
            CSVBuffer.SetFilter("Line No.", '>%1', 1);
            if CSVBuffer.FindSet() then begin
                repeat
                    case CSVBuffer."Field No." of
                        1:
                            begin
                                TempCSVBuffer.Copy(CSVBuffer, true);
                                TempCSVBuffer.SetCurrentKey("Line No.", "Field No.");
                                if TempCSVBuffer.FindLast() then
                                    LastField := TempCSVBuffer."Field No.";

                                ltLineNo := ltLineNo + 10000;
                                ItemJournal.Init();
                                ItemJournal."Journal Template Name" := ltTemplateName;
                                ItemJournal."Journal Batch Name" := ltBatchName;
                                ItemJournal."Line No." := ltLineNo;
                                ItemJournal."Source Code" := ITemJournalTemplate."Source Code";
                                ItemJournal."Entry Type" := ItemJournal."Entry Type"::Transfer;
                                ItemJournal.Insert(true);
                                if Evaluate(ltDate, CSVBuffer.Value) then
                                    ItemJournal.Validate("Posting Date", ltDate);
                                TotalRec := TotalRec + 1;
                            end;
                        2:
                            ItemJournal.Validate("Document No.", CSVBuffer.Value);

                        3:
                            ItemJournal.Validate("Item No.", CSVBuffer.Value);
                        4:
                            ItemJournal.Validate("Location Code", CSVBuffer.Value);
                        5:
                            ItemJournal.Validate("New Location Code", CSVBuffer.Value);
                        6:
                            begin
                                if Evaluate(ltDicimal, CSVBuffer.Value) then
                                    ItemJournal.Validate(Quantity, ltDicimal);
                            end;
                        7:
                            ItemJournal."Temp. Lot No." := CSVBuffer.Value;
                        8:
                            begin
                                if Evaluate(ltDate, CSVBuffer.Value) then
                                    ItemJournal."Temp. Expire Date" := ltDate;
                            end;
                        9:
                            ItemJournal.Validate("Reason Code", CSVBuffer.Value);
                    end;

                    if CSVBuffer."Field No." = LastField then
                        ItemJournal.Modify();

                until CSVBuffer.Next() = 0;
                pItemJournalTemp.copy(ItemJournal, true);
            end;
        end;
    end;

    local procedure InsertLogTransaction(pTableID: Integer; PageName: Text; pDateTime: DateTime; pStatus: Option Successfully,Error; pMsgError: Text; pFileName: Text; pMethodType: Option "Insert","Update","Delete")
    var
        apiLog: Record "FK API Log";
    begin
        apiLog.Init();
        apiLog."Entry No." := GetLastEntryLog();
        apiLog."Method Type" := pMethodType;
        apiLog."Page Name" := PageName;
        apiLog."No." := pTableID;
        apiLog."Date Time" := pDateTime;
        apiLog.Status := pStatus;
        apiLog.Insert(true);
        apiLog."Interface By" := CopyStr(USERID(), 1, 100);
        apiLog."Last Error" := copystr(pMsgError, 1, 2047);
        apiLog."Document No." := COPYSTR(pFileName, 1, 100);
        apiLog.Modify();
    end;

    local procedure InsertLot(pITemJournal: Record "Item Journal Line"; pLotNo: code[50]; pExpireDate: Date)
    var
        ltItem: Record Item;
        TempReservEntry: Record "Reservation Entry" temporary;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ReservStatus: Enum "Reservation Status";
    begin
        ltItem.GET(pITemJournal."Item No.");
        IF ltItem."Item Tracking Code" <> '' then
            if pLotNo <> '' then begin
                TempReservEntry.Init();
                TempReservEntry."Entry No." := GetLastReserveEntry();
                TempReservEntry."Lot No." := pLotNo;
                TempReservEntry.Quantity := pITemJournal.Quantity;
                if pExpireDate <> 0D then
                    TempReservEntry."Expiration Date" := pExpireDate
                else
                    TempReservEntry."Expiration Date" := Today();
                TempReservEntry.Insert();

                CreateReservEntry.SetDates(0D, TempReservEntry."Expiration Date");
                CreateReservEntry.CreateReservEntryFor(Database::"Item Journal Line", pITemJournal."Entry Type".AsInteger(), pITemJournal."Journal Template Name", pITemJournal."Journal Batch Name",
                    0, pITemJournal."Line No.", pITemJournal."Qty. per Unit of Measure", TempReservEntry.Quantity, TempReservEntry.Quantity * pITemJournal."Qty. per Unit of Measure", TempReservEntry);
                CreateReservEntry.CreateEntry(pITemJournal."Item No.", pITemJournal."Variant Code", pITemJournal."Location Code", '', 0D, 0D, 0, ReservStatus::Surplus);
            end;

    end;

    local procedure GetLastReserveEntry(): Integer
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        ReservationEntry.reset();
        ReservationEntry.SetCurrentKey("Entry No.");
        if ReservationEntry.FindLast() then
            exit(ReservationEntry."Entry No." + 1);
        exit(1);
    end;

    local procedure GetLastLineItemJournal(pJournalTemplate: code[10]; pJournalBatch: code[10]): Integer
    var
        ItemJournal: Record "Item Journal Line";
    begin
        ItemJournal.reset();
        ItemJournal.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
        ItemJournal.SetRange("Journal Template Name", pJournalTemplate);
        ItemJournal.SetRange("Journal Batch Name", pJournalBatch);
        if ItemJournal.FindLast() then
            exit(ItemJournal."Line No.");
        exit(10000);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterCopyBuyFromVendorFieldsFromVendor', '', false, false)]
    local procedure OnAfterCopyBuyFromVendorFieldsFromVendor(Vendor: Record Vendor; var PurchaseHeader: Record "Purchase Header")
    begin
        PurchaseHeader."Vendor No. Intranet" := Vendor."Vendor No. Intranet";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Rcpt. Line", 'OnBeforeInsertInvLineFromRcptLine', '', false, false)]
    local procedure OnBeforeInsertInvLineFromRcptLine(var PurchLine: Record "Purchase Line"; var PurchRcptLine: Record "Purch. Rcpt. Line")
    begin
        PurchLine."Ref. GR No. Intranet" := PurchRcptLine."Ref. GR No. Intranet";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Get Receipt", 'OnAfterInsertLines', '', false, false)]
    local procedure OnAfterInsertInvoiceLines(var PurchHeader: Record "Purchase Header")
    var
        PurchaseLine: record "Purchase Line";
    begin
        PurchaseLine.reset();
        PurchaseLine.setrange("Document Type", PurchHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchHeader."No.");
        PurchaseLine.SetFilter("Ref. GR No. Intranet", '<>%1', '');
        if PurchaseLine.FindFirst() then
            PurchHeader."Ref. GR No. Intranet" := PurchaseLine."Ref. GR No. Intranet";

    end;

    /// <summary>
    /// ExportTestTimeOut.
    /// </summary>
    /// <param name="pPageNO">Integer.</param>
    /// <param name="pPageNOSubform">Integer.</param>
    /// <param name="pDocumentType">Enum "Sales Document Type".</param>
    /// <param name="pApiName">Text.</param>
    /// <param name="pPageName">Integer.</param>
    /// <param name="pTableID">Integer.</param>
    /// <param name="pSubTableID">Integer.</param>
    /// <param name="pDocumentNo">Text.</param>
    /// <param name="pJsonFormat">Boolean.</param>
    procedure ExportTestTimeOut(pPageNO: Integer; pPageNOSubform: Integer; pDocumentType: Enum "Sales Document Type"; pApiName: Text;
                                                                                              pPageName: Integer;
                                                                                              pTableID: Integer;
                                                                                              pSubTableID: Integer;
                                                                                              pDocumentNo: Text;
                                                                                              pJsonFormat: Boolean)
    var
        //  PageControl, PageControlDetail : Record "Page Control Field";
        APIMapping, APIMappingLine : Record "API Setup Line";
        ReservationEntry: Record "Reservation Entry";
        ltField: Record Field;
        ltJsonObject, ltResult, ltJsonObjectbuill, ltJsonObjectbuillReserve, ltJsonObjectReserve : JsonObject;
        ltJsonArray, ltJsonArraybuill, ltJsonArrayReserve : JsonArray;
        ltFieldRef: FieldRef;
        ltRecordRef: RecordRef;
        ltText: Text;
        tempBlob: Codeunit "Temp Blob";
        ltOutStr: OutStream;
        ltInstr: InStream;
        ltFileName: Text;
        ValueDecimal: Decimal;
        ValueInteger, ltLineNo, ltloop, ltloop2, ToLine1, ToLine2 : Integer;
        documentNo, TESTdocumentNo : Code[20];
        CR, LF, tab : char;
        CheckFirstLine: Text;
        CheckFirstLineInt, CheckFirstLineInt2 : Integer;
        CheckLineNo: Boolean;
    begin

        if not (pTableID in [36, 38]) then begin
            Message('for sales & purchase');
            exit;
        end;
        CLEAR(ltFieldRef);
        CLEAR(ltJsonObject);
        CLEAR(ltJsonObjectbuill);
        CLEAR(ltJsonArrayReserve);
        CLEAR(ltJsonObjectReserve);
        ToLine1 := 2;
        ToLine2 := 2;
        for ltloop := 1 to ToLine1 do begin
            ltRecordRef.Open(pTableID);
            ltFieldRef := ltRecordRef.FieldIndex(1);
            ltFieldRef.SetRange(pDocumentType);
            if pDocumentNo <> '' then begin
                ltFieldRef := ltRecordRef.FieldIndex(2);
                ltFieldRef.SetFilter(pDocumentNo);
            end;
            if ltRecordRef.FindFirst() then begin
                CLEAR(ltJsonObjectbuill);

                ltFieldRef := ltRecordRef.FieldIndex(2);
                documentNo := format(ltFieldRef.Value);

                TESTdocumentNo := 'TESTAPI_' + format(ltloop);
                ltJsonObjectbuill.Add('documenttype', format(pDocumentType));
                ltJsonObjectbuill.Add('no', TESTdocumentNo);
                CheckFirstLineInt := 0;
                APIMappingLine.reset();
                APIMappingLine.SetCurrentKey("Page Name", "Line Type", "Field No.");
                APIMappingLine.SetRange("Page Name", pPageName);
                APIMappingLine.SetRange("Line Type", APIMappingLine."Line Type"::Header);
                APIMappingLine.SetRange(Include, true);
                APIMappingLine.SetRange("Is Primary", false);
                APIMappingLine.SetFilter("Service Name", '<>%1', '');
                if APIMappingLine.FindSet() then begin
                    repeat
                        ltField.GET(pTableID, APIMappingLine."Field No.");
                        if (ltField.Class = ltField.Class::Normal) and (ltField.Type <> ltField.Type::BLOB) then begin
                            ltFieldRef := ltRecordRef.Field(ltField."No.");
                            if ltField.Type in [ltField.Type::Decimal, ltField.Type::Integer] then begin
                                if ltField.Type = ltField.Type::Integer then begin
                                    Evaluate(ValueInteger, format(ltFieldRef.Value));
                                    if ltJsonObjectbuill.Add(APIMappingLine."Service Name", ValueInteger) then;
                                end else begin
                                    Evaluate(ValueDecimal, format(ltFieldRef.Value));
                                    if ltJsonObjectbuill.Add(APIMappingLine."Service Name", ValueDecimal) then;
                                end;
                            end else
                                if ltJsonObjectbuill.Add(APIMappingLine."Service Name", format(ltFieldRef.Value)) then;
                        end;

                    until APIMappingLine.Next() = 0;
                end;
                ltRecordRef.Close();
                CheckFirstLineInt := 0;
                CheckFirstLineInt2 := 0;
                CLEAR(ltJsonArray);
                for ltloop2 := 1 to ToLine2 do begin

                    CLEAR(ltFieldRef);
                    CheckLineNo := false;
                    ltRecordRef.Open(pSubTableID);
                    ltFieldRef := ltRecordRef.FieldIndex(1);
                    ltFieldRef.SetRange(pDocumentType);
                    ltFieldRef := ltRecordRef.FieldIndex(2);
                    ltFieldRef.SetRange(documentNo);
                    if ltRecordRef.FindFirst() then begin

                        CheckFirstLineInt2 := CheckFirstLineInt2 + 1;

                        CLEAR(ltJsonObject);



                        APIMappingLine.reset();
                        APIMappingLine.SetCurrentKey("Page Name", "Line Type", "Field No.");
                        APIMappingLine.SetRange("Page Name", pPageName);
                        APIMappingLine.SetRange("Line Type", APIMappingLine."Line Type"::Line);
                        APIMappingLine.SetRange(Include, true);
                        APIMappingLine.SetRange("Is Primary", false);
                        APIMappingLine.SetFilter("Service Name", '<>%1', '');
                        if APIMappingLine.FindSet() then
                            repeat

                                ltField.GET(pSubTableID, APIMappingLine."Field No.");
                                if (ltField.Class = ltField.Class::Normal) and (ltField.Type <> ltField.Type::BLOB) then begin
                                    CheckFirstLineInt := CheckFirstLineInt + 1;
                                    CheckFirstLine := '';
                                    if CheckFirstLineInt2 = 1 then begin
                                        if CheckFirstLineInt > 1 then
                                            CheckFirstLine := '@'
                                    end else
                                        CheckFirstLine := '?';

                                    if not CheckLineNo then
                                        ltJsonObject.Add(CheckFirstLine + 'lineno', ltloop2 * 10000);
                                    ltFieldRef := ltRecordRef.Field(ltField."No.");
                                    if ltField.Type in [ltField.Type::Decimal, ltField.Type::Integer] then begin
                                        if ltField.Type = ltField.Type::Integer then begin
                                            Evaluate(ValueInteger, format(ltFieldRef.Value));
                                            if ltJsonObject.Add(CheckFirstLine + APIMappingLine."Service Name", ValueInteger) then;
                                        end else begin
                                            Evaluate(ValueDecimal, format(ltFieldRef.Value));
                                            if ltJsonObject.Add(CheckFirstLine + APIMappingLine."Service Name", ValueDecimal) then;
                                        end;
                                    end else
                                        if ltJsonObject.Add(CheckFirstLine + APIMappingLine."Service Name", format(ltFieldRef.Value)) then;
                                end;
                                CheckLineNo := true;
                            until APIMappingLine.Next() = 0;
                        CLEAR(ltJsonObjectReserve);
                        CLEAR(ltJsonArrayReserve);
                        CheckFirstLineInt := 0;
                        ltFieldRef := ltRecordRef.FieldIndex(3);
                        Evaluate(ltLineNo, format(ltFieldRef.Value));
                        ReservationEntry.reset();
                        ReservationEntry.SetRange("Source ID", documentNo);
                        ReservationEntry.SetRange("Source Ref. No.", ltLineNo);
                        if ReservationEntry.FindSet() then begin
                            repeat
                                CheckFirstLineInt := CheckFirstLineInt + 1;
                                CLEAR(ltJsonObjectReserve);
                                if CheckFirstLineInt = 1 then begin
                                    ltJsonObjectReserve.Add('quantity', ReservationEntry.Quantity);
                                    ltJsonObjectReserve.Add('$lotno', ReservationEntry."Lot No.");
                                    ltJsonObjectReserve.Add('$serialno', ReservationEntry."Serial No.");
                                end else begin
                                    ltJsonObjectReserve.Add('$quantity', ReservationEntry.Quantity);
                                    ltJsonObjectReserve.Add('$lotno', ReservationEntry."Lot No.");
                                    ltJsonObjectReserve.Add('$serialno', ReservationEntry."Serial No.");
                                end;
                                ltJsonArrayReserve.Add(ltJsonObjectReserve);
                            until ReservationEntry.Next() = 0;
                            ltJsonObject.Add('?reservelines', ltJsonArrayReserve);
                        end;
                        ltJsonArray.Add(ltJsonObject);


                        ltRecordRef.Close();
                    end;
                end;

                ltJsonObjectbuill.Add('detaillines', ltJsonArray);
                ltJsonArraybuill.Add(ltJsonObjectbuill);
            end;
        end;

        ltResult.Add(pApiName, ltJsonArraybuill);
        ltResult.WriteTo(ltText);
        if not pJsonFormat then begin
            CR := 13;
            LF := 10;
            tab := 09;
            ltText := ltText.Replace('"', '\"');
            ltText := ltText.Replace(',', ',' + format(CR) + Format(lf) + format(tab) + format(tab) + format(tab) + format(tab));
            ltText := ltText.Replace('\"@', format(tab) + format(tab) + format(tab) + '\"');
            ltText := ltText.Replace('{\"?', format(tab) + format(tab) + format(tab) + '{\"');
            ltText := ltText.Replace('\"?', format(tab) + format(tab) + format(tab) + '\"');
            ltText := ltText.Replace('{\"$', format(tab) + format(tab) + format(tab) + format(tab) + format(tab) + format(tab) + '{\"');
            ltText := ltText.Replace('\"$', format(tab) + format(tab) + format(tab) + format(tab) + format(tab) + format(tab) + '\"');
            ltText := ltText.Replace('\"' + pApiName + '\":', '"' + pApiName + '":"');
            ltText := COPYSTR(ltText, 1, StrLen(ltText) - 1) + '"' + format(CR) + Format(lf) + '}';
        end;
        tempBlob.CreateOutStream(ltOutStr, TextEncoding::UTF8);
        ltOutStr.WriteText(ltText);
        tempBlob.CreateInStream(ltInstr, TextEncoding::UTF8);
        ltFileName := 'API_' + pApiName + '.txt';
        DownloadFromStream(ltInstr, 'Export', '', '', ltFileName)

    end;

    [EventSubscriber(ObjectType::Page, Page::"Vendor Card", 'OnModifyRecordEvent', '', false, false)]
    local procedure OnModifyRecordEventVendor(var Rec: Record Vendor)
    begin
        rec."Already Send" := false;
    end;
    /// <summary>
    /// createcustomer.
    /// </summary>
    /// <param name="customerlists">BigText.</param>
    /// <returns>Return value of type Text.</returns>
    procedure createcustomer(customerlists: BigText): Text;
    var
        ltJsonObject, ltJsonObjectDetail, ltJsonObject2 : JsonObject;
        ltJsonToken, ltJsonToken2 : JsonToken;
        ltJsonArray: JsonArray;
        ltDateTime: DateTime;
        ltPageName: Text;
        ltNoofAPI: Integer;
    begin

        ltPageName := UpperCase('Customer');
        ltNoofAPI := GetNoOfAPI(ltPageName);
        ltDateTime := CurrentDateTime();
        ltJsonToken.ReadFrom(Format(customerlists).Replace('\', ''));
        ltJsonArray := ltJsonToken.AsArray();
        foreach ltJsonToken2 in ltJsonArray do begin
            ltJsonObject2 := ltJsonToken2.AsObject();
            if not InsertTotable(2, Database::Customer, ltJsonObject2) then
                Insertlog(Database::Customer, ltPageName, ltJsonObject2, ltDateTime, GetLastErrorText(), 1, ltNoofAPI, GetLastErrorCode(), SelectJsonTokenText(ltJsonObject2, '$.no'), 0)
            else
                Insertlog(Database::Customer, ltPageName, ltJsonObject2, ltDateTime, '', 0, ltNoofAPI, '', SelectJsonTokenText(ltJsonObject2, '$.no'), 0);

        end;
        exit(ReuturnErrorAPI(ltPageName, ltNoofAPI));
    end;

    /// <summary>
    /// updatecustomer.
    /// </summary>
    /// <param name="customerlists">BigText.</param>
    /// <returns>Return value of type Text.</returns>
    procedure updatecustomer(customerlists: BigText): Text;
    var
        ltJsonObject, ltJsonObjectDetail, ltJsonObject2 : JsonObject;
        ltJsonToken, ltJsonToken2 : JsonToken;
        ltJsonArray: JsonArray;
        ltDateTime: DateTime;
        ltPageName: Text;
        ltNoofAPI: Integer;
    begin

        ltPageName := UpperCase('Customer');
        ltNoofAPI := GetNoOfAPI(ltPageName);
        ltDateTime := CurrentDateTime();
        ltJsonToken.ReadFrom(Format(customerlists).Replace('\', ''));
        ltJsonArray := ltJsonToken.AsArray();
        foreach ltJsonToken2 in ltJsonArray do begin
            ltJsonObject2 := ltJsonToken2.AsObject();
            if not updateTotable(2, Database::Customer, ltJsonObject2) then
                Insertlog(Database::Customer, ltPageName, ltJsonObject2, ltDateTime, GetLastErrorText(), 1, ltNoofAPI, GetLastErrorCode(), SelectJsonTokenText(ltJsonObject2, '$.no'), 1)
            else
                Insertlog(Database::Customer, ltPageName, ltJsonObject2, ltDateTime, '', 0, ltNoofAPI, '', SelectJsonTokenText(ltJsonObject2, '$.no'), 1);

        end;
        exit(ReuturnErrorAPI(ltPageName, ltNoofAPI));
    end;

    /// <summary>
    /// createitem.
    /// </summary>
    /// <param name="itemlists">BigText.</param>
    /// <returns>Return value of type Text.</returns>
    procedure createitem(itemlists: BigText): Text;
    var
        ltJsonObject, ltJsonObjectDetail, ltJsonObject2 : JsonObject;
        ltJsonToken, ltJsonToken2 : JsonToken;
        ltJsonArray: JsonArray;
        ltDateTime: DateTime;
        ltPageName: Text;
        ltNoofAPI: Integer;
    begin
        ltPageName := UpperCase('Item');
        ltNoofAPI := GetNoOfAPI(ltPageName);
        ltDateTime := CurrentDateTime();
        ltJsonToken.ReadFrom(Format(itemlists).Replace('\', ''));
        ltJsonArray := ltJsonToken.AsArray();
        foreach ltJsonToken2 in ltJsonArray do begin
            ltJsonObject2 := ltJsonToken2.AsObject();
            if not InsertTotable(1, Database::Item, ltJsonObject2) then
                Insertlog(Database::Item, ltPageName, ltJsonObject2, ltDateTime, GetLastErrorText(), 1, ltNoofAPI, GetLastErrorCode(), SelectJsonTokenText(ltJsonObject2, '$.no'), 0)
            else
                Insertlog(Database::Item, ltPageName, ltJsonObject2, ltDateTime, '', 0, ltNoofAPI, '', SelectJsonTokenText(ltJsonObject2, '$.no'), 0);
        end;
        exit(ReuturnErrorAPI(ltPageName, ltNoofAPI));
    end;

    /// <summary>
    /// updateitem.
    /// </summary>
    /// <param name="itemlists">BigText.</param>
    /// <returns>Return value of type Text.</returns>
    procedure updateitem(itemlists: BigText): Text;
    var
        ltJsonObject, ltJsonObjectDetail, ltJsonObject2 : JsonObject;
        ltJsonToken, ltJsonToken2 : JsonToken;
        ltJsonArray: JsonArray;
        ltDateTime: DateTime;
        ltPageName: Text;
        ltNoofAPI: Integer;
    begin
        ltPageName := UpperCase('Item');
        ltNoofAPI := GetNoOfAPI(ltPageName);
        ltDateTime := CurrentDateTime();
        ltJsonToken.ReadFrom(Format(itemlists).Replace('\', ''));
        ltJsonArray := ltJsonToken.AsArray();
        foreach ltJsonToken2 in ltJsonArray do begin
            ltJsonObject2 := ltJsonToken2.AsObject();
            if not updateTotable(1, Database::Item, ltJsonObject2) then
                Insertlog(Database::Item, ltPageName, ltJsonObject2, ltDateTime, GetLastErrorText(), 1, ltNoofAPI, GetLastErrorCode(), SelectJsonTokenText(ltJsonObject2, '$.no'), 1)
            else
                Insertlog(Database::Item, ltPageName, ltJsonObject2, ltDateTime, '', 0, ltNoofAPI, '', SelectJsonTokenText(ltJsonObject2, '$.no'), 1);
        end;
        exit(ReuturnErrorAPI(ltPageName, ltNoofAPI));
    end;
    /// <summary>
    /// createvendor.
    /// </summary>
    /// <param name="vendorlists">BigText.</param>
    /// <returns>Return value of type Text.</returns>
    procedure createvendor(vendorlists: BigText): Text;
    var
        ltJsonObject, ltJsonObjectDetail, ltJsonObject2 : JsonObject;
        ltJsonToken, ltJsonToken2 : JsonToken;
        ltJsonArray: JsonArray;
        ltDateTime: DateTime;
        ltPageName: Text;
        ltNoofAPI: Integer;
    begin
        ltPageName := UpperCase('Vendor');
        ltNoofAPI := GetNoOfAPI(ltPageName);
        ltDateTime := CurrentDateTime();
        ltJsonToken.ReadFrom(Format(vendorlists).Replace('\', ''));
        ltJsonArray := ltJsonToken.AsArray();
        foreach ltJsonToken2 in ltJsonArray do begin
            ltJsonObject2 := ltJsonToken2.AsObject();
            if not InsertTotable(3, Database::vendor, ltJsonObject2) then
                Insertlog(Database::Vendor, ltPageName, ltJsonObject2, ltDateTime, GetLastErrorText(), 1, ltNoofAPI, GetLastErrorCode(), SelectJsonTokenText(ltJsonObject2, '$.no'), 0)
            else
                Insertlog(Database::Vendor, ltPageName, ltJsonObject2, ltDateTime, '', 0, ltNoofAPI, '', SelectJsonTokenText(ltJsonObject2, '$.no'), 0);
        end;
        exit(ReuturnErrorAPI(ltPageName, ltNoofAPI));
    end;

    /// <summary>
    /// updateVendor.
    /// </summary>
    /// <param name="vendorlists">BigText.</param>
    /// <returns>Return value of type Text.</returns>
    procedure updatevendor(vendorlists: BigText): Text;
    var
        ltJsonObject, ltJsonObjectDetail, ltJsonObject2 : JsonObject;
        ltJsonToken, ltJsonToken2 : JsonToken;
        ltJsonArray: JsonArray;
        ltDateTime: DateTime;
        ltPageName: Text;
        ltNoofAPI: Integer;
    begin
        ltPageName := UpperCase('Vendor');
        ltNoofAPI := GetNoOfAPI(ltPageName);
        ltDateTime := CurrentDateTime();
        ltJsonToken.ReadFrom(Format(vendorlists).Replace('\', ''));
        ltJsonArray := ltJsonToken.AsArray();
        foreach ltJsonToken2 in ltJsonArray do begin
            ltJsonObject2 := ltJsonToken2.AsObject();
            if not UpdateTotable(3, Database::vendor, ltJsonObject2) then
                Insertlog(Database::Vendor, ltPageName, ltJsonObject2, ltDateTime, GetLastErrorText(), 1, ltNoofAPI, GetLastErrorCode(), SelectJsonTokenText(ltJsonObject2, '$.no'), 1)
            else
                Insertlog(Database::Vendor, ltPageName, ltJsonObject2, ltDateTime, '', 0, ltNoofAPI, '', SelectJsonTokenText(ltJsonObject2, '$.no'), 1);
        end;
        exit(ReuturnErrorAPI(ltPageName, ltNoofAPI));
    end;

    /// <summary>
    /// callandsendvendor.
    /// </summary>
    procedure callandsendvendorbyJob()
    var
        ltDateTime: DateTime;
        ltNoofAPI: Integer;
    begin
        ltDateTime := CurrentDateTime();
        ltNoofAPI := GetNoOfAPI('Vendor');
        // sendtointranet(Database::Vendor);
        // if not sendvendor() then
        //     Insertlog(Database::Vendor, 'Vendor', ltJsonObject2, ltDateTime, GetLastErrorText(), 1, ltNoofAPI)
    end;

    /// <summary>
    /// callandsendvendorManual.
    /// </summary>
    procedure callandsendvendorManual()
    begin
        if not Confirm(StrSubstNo('Do you wany to send a vendor no.%1', gvNo)) then
            exit;
        sendtointranet(Database::Vendor);
    end;

    /// <summary>
    /// callandsendcustomerManual.
    /// </summary>
    procedure callandsendcustomerManual()
    begin
        if not Confirm(StrSubstNo('Do you wany to send a customer no.%1', gvNo)) then
            exit;
        sendtointranet(Database::Customer);
    end;

    /// <summary>
    /// callandsenditemManual.
    /// </summary>
    procedure callandsenditemManual()
    begin
        if not Confirm(StrSubstNo('Do you wany to send a item no.%1', gvNo)) then
            exit;
        sendtointranet(Database::Item);
    end;

    /// <summary>
    /// setDocumentNo.
    /// </summary>
    /// <param name="pNo">Text.</param>
    procedure setDocumentNo(pNo: Text)
    begin
        gvNo := pNo;
    end;

    //[TryFunction]
    local procedure sendtointranet(pTableID: Integer)
    var

        apisetupline: Record "API Setup Line";
        apiSetupHeader: Record "API Setup Header";
        TempBlob: Codeunit "Temp Blob";
        ltRecordRef: RecordRef;
        ltFieldRef: FieldRef;
        ltJsonObject, ltJsonObjectBiuld : JsonObject;
        ltJsonArray: JsonArray;
        ltInteger: Integer;
        ltDecimal: Decimal;
        ltURL, ltpayload, ltFileName : Text;
        ltStr: InStream;
        ltOutStr: OutStream;
        CR, LF, TAB : Char;
        ltPageNo: Enum "FK Api Page Type";
    begin
        ltpayload := '';
        if pTableID = Database::item then
            ltPageNo := ltPageNo::Item;
        if pTableID = Database::Customer then
            ltPageNo := ltPageNo::Customer;
        if pTableID = Database::Vendor then
            ltPageNo := ltPageNo::Vendor;

        apiSetupHeader.GET(ltPageNo);
        apiSetupHeader.TestField("Serivce Name");
        //  apiSetupHeader.TestField(URL);
        ltURL := apiSetupHeader.URL;
        CLEAR(ltJsonArray);
        CLEAR(ltJsonObjectBiuld);
        ltRecordRef.Open(pTableID);
        ltFieldRef := ltRecordRef.Field(70000);
        ltFieldRef.SetRange(false);
        if gvNo <> '' then begin
            ltFieldRef := ltRecordRef.FieldIndex(1);
            ltFieldRef.SetFilter(gvNo);
        end;
        if pTableID = Database::Vendor then begin
            ltFieldRef := ltRecordRef.Field(60060);
            ltFieldRef.SetRange(true);
        end;
        if ltRecordRef.FindSet() then begin
            repeat
                CLEAR(ltJsonObject);
                apisetupline.reset();
                apisetupline.SetRange("Page Name", apisetupline."Page Name"::Vendor);
                apisetupline.SetRange(Include, true);
                apisetupline.SetFilter("Field No.", '<>%1', 0);
                if apisetupline.FindSet() then
                    repeat
                        ltFieldRef := ltRecordRef.Field(apisetupline."Field No.");
                        if UpperCase(format(ltFieldRef.Type)) IN ['INTEGER', 'DECIMAL'] then begin
                            if UpperCase(format(ltFieldRef.Type)) = 'INTEGER' then begin
                                Evaluate(ltInteger, format(ltFieldRef.Value));
                                ltJsonObject.Add(apisetupline."Service Name", ltInteger)
                            end;
                            if UpperCase(format(ltFieldRef.Type)) = 'DECIMAL' then begin
                                Evaluate(ltDecimal, format(ltFieldRef.Value));
                                ltJsonObject.Add(apisetupline."Service Name", ltDecimal)
                            end;
                        end else
                            ltJsonObject.Add(apisetupline."Service Name", format(ltFieldRef.Value));
                    until apisetupline.Next() = 0;
                ltJsonArray.Add(ltJsonObject);
            until ltRecordRef.next = 0;
            ltURL := '';
            ltJsonObjectBiuld.Add(apiSetupHeader."Serivce Name", ltJsonArray);
            ltJsonObjectBiuld.WriteTo(ltpayload);
            TempBlob.CreateOutStream(ltOutStr, TextEncoding::UTF8);
            CR := 13;
            LF := 10;
            tab := 09;
            ltpayload := ltpayload.Replace(',', ',' + format(CR) + Format(lf) + format(tab) + format(tab) + format(tab));
            ltpayload := COPYSTR(ltpayload, 1, StrLen(ltpayload) - 1) + format(CR) + Format(lf) + '}';
            ltOutStr.WriteText(ltpayload);
            TempBlob.CreateInStream(ltStr, TextEncoding::UTF8);
            ltFileName := apiSetupHeader."Serivce Name" + '.txt';
            DownloadFromStream(ltStr, '', '', '', ltFileName);
            if (ltURL <> '') and (ltpayload <> '') then begin
                ConnectToWebService(ltpayload, ltURL);
                ltFieldRef := ltRecordRef.Field(70000);
                ltFieldRef.Value := true;
                ltRecordRef.Modify();
            end;
        end;
        ltRecordRef.Close();
    end;

    /// <summary>
    /// purchaseorder.
    /// </summary>
    /// <param name="purchaseorderlists">BigText.</param>
    /// <returns>Return value of type Text.</returns>
    procedure purchaseorder(purchaseorderlists: BigText): Text;
    var
        ltJsonObject, ltJsonObjectDetail, ltJsonObject2 : JsonObject;
        ltJsonToken, ltJsonToken2 : JsonToken;
        ltJsonArray: JsonArray;
        ltDateTime: DateTime;
        ltPageName: Text;
        ltNoofAPI: Integer;
        ltDocumentType: Enum "Purchase Document Type";
    begin
        ltPageName := UpperCase('Purchase Order');
        ltNoofAPI := GetNoOfAPI(ltPageName);
        ltDateTime := CurrentDateTime();
        ltJsonToken.ReadFrom(Format(purchaseorderlists).Replace('\', ''));
        ltJsonArray := ltJsonToken.AsArray();
        foreach ltJsonToken2 in ltJsonArray do begin
            ltJsonObject2 := ltJsonToken2.AsObject();
            if not InsertTotable(4, Database::"Purchase Header", ltJsonObject2) then begin
                Insertlog(Database::"Purchase Header", ltPageName, ltJsonObject2, ltDateTime, GetLastErrorText(), 1, ltNoofAPI, GetLastErrorCode(), SelectJsonTokenText(ltJsonObject2, '$.no'), 0);
                DeleteDocAfterGetError(Database::"Purchase Header", ltDocumentType::Order.AsInteger(), SelectJsonTokenText(ltJsonObject2, '$.no'));
            end
            else begin
                UpdatePurchaseStatusToRelease(ltDocumentType::Order, SelectJsonTokenText(ltJsonObject2, '$.no'));
                Insertlog(Database::"Purchase Header", ltPageName, ltJsonObject2, ltDateTime, '', 0, ltNoofAPI, '', SelectJsonTokenText(ltJsonObject2, '$.no'), 0);
            end;
        end;
        exit(ReuturnErrorAPI(ltPageName, ltNoofAPI));
    end;

    /// <summary>
    /// purchasereturnorder.
    /// </summary>
    /// <param name="purchasereturnorderlists">BigText.</param>
    /// <returns>Return value of type Text.</returns>
    procedure purchasereturnorder(purchasereturnorderlists: BigText): Text;
    var
        ltJsonObject, ltJsonObjectDetail, ltJsonObject2 : JsonObject;
        ltJsonToken, ltJsonToken2 : JsonToken;
        ltJsonArray: JsonArray;
        ltDateTime: DateTime;
        ltPageName: Text;
        ltNoofAPI: Integer;
        ltDocumentType: Enum "Purchase Document Type";
    begin
        ltPageName := UpperCase('Purchase Return Order');
        ltNoofAPI := GetNoOfAPI(ltPageName);
        ltDateTime := CurrentDateTime();
        ltJsonToken.ReadFrom(Format(purchasereturnorderlists).Replace('\', ''));
        ltJsonArray := ltJsonToken.AsArray();
        foreach ltJsonToken2 in ltJsonArray do begin
            ltJsonObject2 := ltJsonToken2.AsObject();
            if not InsertTotable(5, Database::"Purchase Header", ltJsonObject2) then begin
                Insertlog(Database::"Purchase Header", ltPageName, ltJsonObject2, ltDateTime, GetLastErrorText(), 1, ltNoofAPI, GetLastErrorCode(), SelectJsonTokenText(ltJsonObject2, '$.no'), 0);
                DeleteDocAfterGetError(Database::"Purchase Header", ltDocumentType::"Return Order".AsInteger(), SelectJsonTokenText(ltJsonObject2, '$.no'));
            end else begin
                UpdatePurchaseStatusToRelease(ltDocumentType::"Return Order", SelectJsonTokenText(ltJsonObject2, '$.no'));
                Insertlog(Database::"Purchase Header", ltPageName, ltJsonObject2, ltDateTime, '', 0, ltNoofAPI, '', SelectJsonTokenText(ltJsonObject2, '$.no'), 0);
            end;
        end;
        exit(ReuturnErrorAPI(ltPageName, ltNoofAPI));
    end;


    /// <summary>
    /// goodreceiptnote.
    /// </summary>
    /// <param name="goodreceiptnotelists">BigText.</param>
    /// <returns>Return value of type Text.</returns>
    procedure goodreceiptnote(goodreceiptnotelists: BigText): Text
    var

        ltJsonObject, ltJsonObjectDetail, ltJsonObject2 : JsonObject;
        ltJsonToken, ltJsonToken2 : JsonToken;
        ltDocumentType: Enum "Purchase Document Type";
        ltJsonArray: JsonArray;
        ltDateTime: DateTime;
        ltPageName: Text;
        ltNoofAPI: Integer;
    begin
        ltPageName := UpperCase('Good Receipt Note');
        ltNoofAPI := GetNoOfAPI(ltPageName);
        ltDateTime := CurrentDateTime();
        ltJsonToken.ReadFrom(Format(goodreceiptnotelists).Replace('\', ''));
        ltJsonArray := ltJsonToken.AsArray();
        foreach ltJsonToken2 in ltJsonArray do begin
            ltJsonObject2 := ltJsonToken2.AsObject();
            if not updateqtypurchase(ltDocumentType::Order, SelectJsonTokenText(ltJsonObject2, '$.documentno'), SelectJsonTokenText(ltJsonObject2, '$.no'), 1, true) then
                Insertlog(Database::"Purchase Line", ltPageName, ltJsonObject2, ltDateTime, GetLastErrorText(), 1, ltNoofAPI, GetLastErrorCode(), SelectJsonTokenText(ltJsonObject2, '$.documentno'), 1)
            else
                Insertlog(Database::"Purchase Line", ltPageName, ltJsonObject2, ltDateTime, '', 0, ltNoofAPI, '', SelectJsonTokenText(ltJsonObject2, '$.documentno'), 1);
        end;
        exit(ReuturnErrorAPI(ltPageName, ltNoofAPI));
    end;

    /// <summary>
    /// returnreceipt.
    /// </summary>
    /// <param name="returnreceiptlists">BigText.</param>
    /// <returns>Return value of type Text.</returns>
    procedure returnreceipt(returnreceiptlists: BigText): Text
    var

        ltJsonObject, ltJsonObjectDetail, ltJsonObject2 : JsonObject;
        ltJsonToken, ltJsonToken2 : JsonToken;
        ltDocumentType: Enum "Purchase Document Type";
        ltJsonArray: JsonArray;
        ltDateTime: DateTime;
        ltPageName: Text;
        ltNoofAPI: Integer;
    begin
        ltPageName := UpperCase('Return Receipt');
        ltNoofAPI := GetNoOfAPI(ltPageName);
        ltDateTime := CurrentDateTime();
        ltJsonToken.ReadFrom(Format(returnreceiptlists).Replace('\', ''));
        ltJsonArray := ltJsonToken.AsArray();
        foreach ltJsonToken2 in ltJsonArray do begin
            ltJsonObject2 := ltJsonToken2.AsObject();
            if not updateqtypurchase(ltDocumentType::"Return Order", SelectJsonTokenText(ltJsonObject2, '$.documentno'), SelectJsonTokenText(ltJsonObject2, '$.no'), 1, false) then
                Insertlog(Database::"Purchase Line", ltPageName, ltJsonObject2, ltDateTime, GetLastErrorText(), 1, ltNoofAPI, GetLastErrorCode(), SelectJsonTokenText(ltJsonObject2, '$.documentno'), 1)
            else
                Insertlog(Database::"Purchase Line", ltPageName, ltJsonObject2, ltDateTime, '', 0, ltNoofAPI, '', SelectJsonTokenText(ltJsonObject2, '$.documentno'), 1);
        end;
        exit(ReuturnErrorAPI(ltPageName, ltNoofAPI));
    end;
    /// <summary>
    /// salesinvoice.
    /// </summary>
    /// <param name="salesinvoicelists">BigText.</param>
    /// <returns>Return value of type Text.</returns>
    procedure salesinvoice(salesinvoicelists: BigText): Text;
    var
        ltJsonObject, ltJsonObjectDetail, ltJsonObject2 : JsonObject;
        ltJsonToken, ltJsonToken2 : JsonToken;
        ltJsonArray: JsonArray;
        ltDateTime: DateTime;
        ltPageName: Text;
        ltNoofAPI: Integer;
        ltDocumentType: Enum "Sales Document Type";
    begin
        ltPageName := UpperCase('Sales Invoice');
        ltNoofAPI := GetNoOfAPI(ltPageName);
        ltDateTime := CurrentDateTime();
        ltJsonToken.ReadFrom(Format(salesinvoicelists).Replace('\', ''));
        ltJsonArray := ltJsonToken.AsArray();
        foreach ltJsonToken2 in ltJsonArray do begin
            ltJsonObject2 := ltJsonToken2.AsObject();
            if not InsertTotable(8, Database::"Sales Header", ltJsonObject2) then begin
                Insertlog(Database::"Sales Header", ltPageName, ltJsonObject2, ltDateTime, GetLastErrorText(), 1, ltNoofAPI, GetLastErrorCode(), SelectJsonTokenText(ltJsonObject2, '$.no'), 0);
                DeleteDocAfterGetError(Database::"Sales Header", ltDocumentType::Invoice.AsInteger(), SelectJsonTokenText(ltJsonObject2, '$.no'));
            end
            else begin
                UpdateSalesStatusToRelease(ltDocumentType::Invoice, SelectJsonTokenText(ltJsonObject2, '$.no'));
                Insertlog(Database::"Sales Header", ltPageName, ltJsonObject2, ltDateTime, '', 0, ltNoofAPI, '', SelectJsonTokenText(ltJsonObject2, '$.no'), 0);
            end;
        end;
        exit(ReuturnErrorAPI(ltPageName, ltNoofAPI));
    end;


    /// <summary>
    /// salescreditmemo.
    /// </summary>
    /// <param name="salescreditmemolists">BigText.</param>
    /// <returns>Return value of type Text.</returns>
    procedure salescreditmemo(salescreditmemolists: BigText): Text;
    var
        ltJsonObject, ltJsonObjectDetail, ltJsonObject2 : JsonObject;
        ltJsonToken, ltJsonToken2 : JsonToken;
        ltJsonArray: JsonArray;
        ltDateTime: DateTime;
        ltPageName: Text;
        ltNoofAPI: Integer;
        ltDocumentType: Enum "Sales Document Type";
    begin
        ltPageName := UpperCase('Sales Credit Memo');
        ltNoofAPI := GetNoOfAPI(ltPageName);
        ltDateTime := CurrentDateTime();
        ltJsonToken.ReadFrom(Format(salescreditmemolists).Replace('\', ''));
        ltJsonArray := ltJsonToken.AsArray();
        foreach ltJsonToken2 in ltJsonArray do begin
            ltJsonObject2 := ltJsonToken2.AsObject();
            if not InsertTotable(9, Database::"Sales Header", ltJsonObject2) then begin
                Insertlog(Database::"Sales Header", ltPageName, ltJsonObject2, ltDateTime, GetLastErrorText(), 1, ltNoofAPI, GetLastErrorCode(), SelectJsonTokenText(ltJsonObject2, '$.no'), 0);
                DeleteDocAfterGetError(Database::"Sales Header", ltDocumentType::"Credit Memo".AsInteger(), SelectJsonTokenText(ltJsonObject2, '$.no'));
            end
            else begin
                UpdateSalesStatusToRelease(ltDocumentType::"Credit Memo", SelectJsonTokenText(ltJsonObject2, '$.no'));
                Insertlog(Database::"Sales Header", ltPageName, ltJsonObject2, ltDateTime, '', 0, ltNoofAPI, '', SelectJsonTokenText(ltJsonObject2, '$.no'), 0);
            end;
        end;
        exit(ReuturnErrorAPI(ltPageName, ltNoofAPI));
    end;

    [TryFunction]
    local procedure updateqtypurchase(pDocumentType: Enum "Purchase Document Type"; pDocumentNo: code[30];
                                                         pItemNo: code[30];
                                                         pQty: Decimal;
                                                         pGoodReceipt: Boolean)
    var
        purchaseLine: Record "Purchase Line";
    begin
        purchaseLine.reset();
        purchaseLine.SetRange("Document Type", pDocumentType);
        purchaseLine.SetRange("Document No.", pDocumentNo);
        purchaseLine.SetRange("No.", pItemNo);
        if purchaseLine.FindFirst() then begin
            if pGoodReceipt then
                purchaseLine.Validate("Qty. to Receive", pQty)
            else
                purchaseLine.Validate("Return Qty. to Ship", pQty);
            purchaseLine.Modify();
        end;
    end;


    local procedure UpdatePurchaseStatusToRelease(pDocumentType: Enum "Purchase Document Type"; pDocumentNo: code[30])
    var
        PurchaseHeader: record "Purchase Header";
    begin
        if PurchaseHeader.GET(pDocumentType, pDocumentNo) then begin
            PurchaseHeader.Status := PurchaseHeader.Status::Released;
            PurchaseHeader.Modify();
        end;
    end;

    local procedure UpdateSalesStatusToRelease(pDocumentType: Enum "Sales Document Type"; pDocumentNo: code[30])
    var
        SalesHeader: record "Sales Header";
    begin
        if SalesHeader.GET(pDocumentType, pDocumentNo) then begin
            SalesHeader.Status := SalesHeader.Status::Released;
            SalesHeader.Modify();
        end;
    end;

    [TryFunction]
    local procedure UpdateTotable(pPageName: Option; pTableID: Integer; pJsonObject: JsonObject)
    var
        APIMappingHeader: Record "API Setup Header";
        APIMappingLine: Record "API Setup Line";
        ltFieldRef: FieldRef;
        ltRecordRef: RecordRef;
        ltField: Record Field;
        ltJsonTokenReserve: JsonToken;
        TemplateName, BatchName : Code[30];
        ltLineNo, ltIndexof, ltIndexofDetail : Integer;
        ltDate: Date;
        ltDocNo: Code[30];
    begin
        APIMappingHeader.GET(pPageName);
        APIMappingLine.reset();
        APIMappingLine.SetCurrentKey("Page Name", "Line Type", "Field No.");
        APIMappingLine.SetRange("Page Name", APIMappingHeader."Page Name");
        APIMappingLine.SetRange("Line Type", APIMappingLine."Line Type"::Header);
        APIMappingLine.SetRange(Include, true);
        APIMappingLine.SetFilter("Service Name", '<>%1', '');
        APIMappingLine.SetRange("Is Primary", true);
        if APIMappingLine.FindSet() then begin
            ltDocNo := SelectJsonTokenText(pJsonObject, '$.' + APIMappingLine."Service Name");
            ltRecordRef.Open(APIMappingHeader."Table ID");
            ltFieldRef := ltRecordRef.Field(APIMappingLine."Field No.");
            ltFieldRef.SetFilter(ltDocNo);
            if ltRecordRef.FindFirst() then begin
                APIMappingLine.SetRange("Is Primary", false);
                if APIMappingLine.FindSet() then begin
                    repeat
                        ltFieldRef := ltRecordRef.FIELD(APIMappingLine."Field No.");
                        if ltFieldRef.Type IN [ltFieldRef.Type::Integer, ltFieldRef.Type::Decimal, ltFieldRef.Type::Option] then
                            if ltFieldRef.Type = ltFieldRef.Type::Option then begin
                                ltIndexofDetail := SelectOption(ltFieldRef.OptionCaption, SelectJsonTokenText(pJsonObject, '$.' + APIMappingLine."Service Name"));
                                ltFieldRef.validate(ltIndexofDetail);
                            end else
                                ltFieldRef.validate(SelectJsonTokenInterger(pJsonObject, '$.' + APIMappingLine."Service Name"))
                        else
                            if ltFieldRef.Type = ltFieldRef.Type::Date then begin
                                Evaluate(ltDate, SelectJsonTokenText(pJsonObject, '$.' + APIMappingLine."Service Name"));
                                ltFieldRef.Validate(ltDate);
                            end else
                                ltFieldRef.Validate(SelectJsonTokenText(pJsonObject, '$.' + APIMappingLine."Service Name"));
                    until APIMappingLine.Next() = 0;

                    ltRecordRef.Modify(true);
                end;
                ltRecordRef.Close();
            end else begin
                if APIMappingHeader."Page Name" = APIMappingHeader."Page Name"::Vendor then
                    ERROR('Vendor no. %1 does not exists', ltDocNo);
                if APIMappingHeader."Page Name" = APIMappingHeader."Page Name"::Item then
                    ERROR('Item no %1 does not exists', ltDocNo);
                if APIMappingHeader."Page Name" = APIMappingHeader."Page Name"::Customer then
                    ERROR('Customer no. %1 does not exists', ltDocNo);
            end;
        end;
    end;


    [TryFunction]
    local procedure InsertTotable(pPageName: Option; pTableID: Integer; pJsonObject: JsonObject)
    var
        APIMappingHeader: Record "API Setup Header";
        APIMappingLine: Record "API Setup Line";
        ltFieldRef: FieldRef;
        ltRecordRef: RecordRef;
        ltField: Record Field;
        ltJsonTokenReserve: JsonToken;
        TemplateName, BatchName : Code[30];
        ltLineNo, ltIndexof, ltIndexofDetail : Integer;
        ltDate: Date;
        ltDocNo: Code[30];
    begin
        APIMappingHeader.GET(pPageName);
        ltRecordRef.Open(APIMappingHeader."Table ID");
        ltRecordRef.Init();
        APIMappingLine.reset();
        APIMappingLine.SetCurrentKey("Page Name", "Line Type", "Field No.");
        APIMappingLine.SetRange("Page Name", APIMappingHeader."Page Name");
        APIMappingLine.SetRange("Line Type", APIMappingLine."Line Type"::Header);
        APIMappingLine.SetRange(Include, true);
        APIMappingLine.SetFilter("Service Name", '<>%1', '');
        APIMappingLine.SetRange("Is Primary", true);
        if APIMappingLine.FindSet() then
            repeat
                ltFieldRef := ltRecordRef.FIELD(APIMappingLine."Field No.");
                if ltFieldRef.Type IN [ltFieldRef.Type::Integer, ltFieldRef.Type::Decimal, ltFieldRef.Type::Option] then
                    if ltFieldRef.Type = ltFieldRef.Type::Option then begin
                        ltIndexof := SelectOption(ltFieldRef.OptionCaption, SelectJsonTokenText(pJsonObject, '$.' + APIMappingLine."Service Name"));
                        ltFieldRef.validate(ltIndexof);
                    end else
                        ltFieldRef.validate(SelectJsonTokenInterger(pJsonObject, '$.' + APIMappingLine."Service Name"))
                else
                    if ltFieldRef.Type = ltFieldRef.Type::Date then begin
                        Evaluate(ltDate, SelectJsonTokenText(pJsonObject, '$.' + APIMappingLine."Service Name"));
                        ltFieldRef.Validate(ltDate);
                    end else begin
                        ltDocNo := SelectJsonTokenText(pJsonObject, '$.' + APIMappingLine."Service Name");
                        ltFieldRef.Validate(ltDocNo);
                    end;
            until APIMappingLine.Next() = 0;
        ltRecordRef.Insert(true);
        APIMappingLine.SetRange("Is Primary", false);
        if APIMappingHeader."Table ID" = Database::Customer then begin
            APIMappingLine.SetFilter("Field No.", '<>%1', 12);
        end;
        if APIMappingLine.FindSet() then begin
            repeat
                ltFieldRef := ltRecordRef.FIELD(APIMappingLine."Field No.");
                if ltFieldRef.Type IN [ltFieldRef.Type::Integer, ltFieldRef.Type::Decimal, ltFieldRef.Type::Option] then
                    if ltFieldRef.Type = ltFieldRef.Type::Option then begin
                        ltIndexofDetail := SelectOption(ltFieldRef.OptionCaption, SelectJsonTokenText(pJsonObject, '$.' + APIMappingLine."Service Name"));
                        ltFieldRef.validate(ltIndexofDetail);
                    end else
                        ltFieldRef.validate(SelectJsonTokenInterger(pJsonObject, '$.' + APIMappingLine."Service Name"))
                else
                    if ltFieldRef.Type = ltFieldRef.Type::Date then begin
                        Evaluate(ltDate, SelectJsonTokenText(pJsonObject, '$.' + APIMappingLine."Service Name"));
                        ltFieldRef.Validate(ltDate);
                    end else
                        ltFieldRef.Validate(SelectJsonTokenText(pJsonObject, '$.' + APIMappingLine."Service Name"));
            until APIMappingLine.Next() = 0;
            ltRecordRef.Modify(true);
        end;
        if APIMappingHeader."Table ID" = Database::Customer then
            CreateShiptoCode(ltDocNo, pJsonObject, SelectJsonTokenText(pJsonObject, '$.shiptocode'));


        // IF APIMappingHeader."Sub Table ID" <> 0 then
        //     InsertTotableLine(pJsonObject, APIMappingHeader."Sub Table ID", APIMappingHeader."Page Name", APIMappingHeader."Sub Page No.", ltIndexof, ltDocNo)
        // else
        //     if APIMappingHeader."Table ID" = Database::"Item Journal Line" then
        //         if pJsonObject.SelectToken('$.reservelines', ltJsonTokenReserve) then begin
        //             ltFieldRef := ltRecordRef.FieldIndex(1);
        //             TemplateName := format(ltFieldRef.Value);
        //             ltFieldRef := ltRecordRef.FieldIndex(2);
        //             BatchName := format(ltFieldRef.Value);
        //             ltFieldRef := ltRecordRef.FieldIndex(3);
        //             Evaluate(ltLineNo, format(ltFieldRef.Value));
        //             ItemJournalInsertReserveLine(TemplateName, BatchName, ltLineNo, ltJsonTokenReserve);
        //         end;
        ltRecordRef.Close();
    end;

    local procedure CreateShiptoCode(pCustomerCode: code[30]; pJsonObject: JsonObject; pShiptoCode: code[20])
    var
        Customer: Record Customer;
        ltJsonObjectDetail: JsonObject;
        APIMappingLine: Record "API Setup Line";
        ltJsonToken: JsonToken;
        ltJsonArray: JsonArray;
        ltJsonTokenDetail, ltJsonTokenReserve : JsonToken;
        ltFieldRef: FieldRef;
        ltRecordRef: RecordRef;
        ltField: Record Field;
        ltLineNo: Integer;
        ltDate: Date;
        ltCheckLine: JsonToken;

    begin
        if pJsonObject.SelectToken('$.shiptodetail', ltJsonToken) then begin
            ltJsonArray := ltJsonToken.AsArray();
            foreach ltJsonTokenDetail in ltJsonArray do begin
                ltJsonObjectDetail := ltJsonTokenDetail.AsObject();
                if SelectJsonTokenText(ltJsonObjectDetail, '$.code') <> '' then begin
                    ltRecordRef.Open(Database::"Ship-to Address");
                    ltRecordRef.Init();
                    ltFieldRef := ltRecordRef.FieldIndex(1);
                    ltFieldRef.validate(pCustomerCode);
                    ltFieldRef := ltRecordRef.FieldIndex(2);
                    ltFieldRef.validate(SelectJsonTokenText(ltJsonObjectDetail, '$.code'));
                    ltRecordRef.Insert(true);
                    ltFieldRef := ltRecordRef.Field(3);
                    ltFieldRef.validate(SelectJsonTokenText(ltJsonObjectDetail, '$.name'));
                    ltFieldRef := ltRecordRef.Field(5);
                    ltFieldRef.validate(SelectJsonTokenText(ltJsonObjectDetail, '$.address'));
                    ltFieldRef := ltRecordRef.Field(6);
                    ltFieldRef.validate(SelectJsonTokenText(ltJsonObjectDetail, '$.address2'));
                    ltFieldRef := ltRecordRef.Field(7);
                    ltFieldRef.validate(SelectJsonTokenText(ltJsonObjectDetail, '$.city'));
                    ltFieldRef := ltRecordRef.Field(8);
                    ltFieldRef.validate(SelectJsonTokenText(ltJsonObjectDetail, '$.contact'));
                    ltFieldRef := ltRecordRef.Field(83);
                    ltFieldRef.validate(SelectJsonTokenText(ltJsonObjectDetail, '$.locationcode'));
                    ltFieldRef := ltRecordRef.Field(91);
                    ltFieldRef.validate(SelectJsonTokenText(ltJsonObjectDetail, '$.postcode'));
                    ltRecordRef.Modify();
                    ltRecordRef.Close();
                end;
            end;
        end;
        if pShiptoCode <> '' then begin
            if Customer.GET(pCustomerCode) then begin
                Customer."Ship-to Code" := pShiptoCode;
                Customer.Modify();
            end;
        end;
    end;

    local procedure InsertTotableLine(pJsonObject: JsonObject; subtableID: Integer; pPageID: Enum "FK Api Page Type"; pSubPageID: Integer;
                                                                                                 pDocumentType: Integer;
                                                                                                 pDocumentNo: code[30])
    var
        ltJsonObjectDetail: JsonObject;
        APIMappingLine: Record "API Setup Line";
        ltJsonToken: JsonToken;
        ltJsonArray: JsonArray;
        ltJsonTokenDetail, ltJsonTokenReserve : JsonToken;
        ltFieldRef: FieldRef;
        ltRecordRef: RecordRef;
        ltField: Record Field;
        ltLineNo: Integer;
        ltDate: Date;
        ltCheckLine: JsonToken;
    begin
        if pJsonObject.SelectToken('$.detaillines', ltJsonToken) then begin
            ltJsonArray := ltJsonToken.AsArray();
            foreach ltJsonTokenDetail in ltJsonArray do begin
                ltJsonObjectDetail := ltJsonTokenDetail.AsObject();
                ltRecordRef.Open(subtableID);
                ltRecordRef.Init();
                ltFieldRef := ltRecordRef.FieldIndex(1);
                ltFieldRef.validate(pDocumentType);
                ltFieldRef := ltRecordRef.FieldIndex(2);
                ltFieldRef.validate(pDocumentNo);
                ltFieldRef := ltRecordRef.FieldIndex(3);
                if ltJsonObjectDetail.SelectToken('$.lineno', ltCheckLine) then
                    ltFieldRef.validate(SelectJsonTokenInterger(ltJsonObjectDetail, '$.lineno'))
                else
                    ltFieldRef.validate(GetLastLine(subtableID, pDocumentType, pDocumentNo));
                ltLineNo := ltFieldRef.Value;
                ltRecordRef.Insert(true);

                APIMappingLine.reset();
                APIMappingLine.SetCurrentKey("Page Name", "Line Type", "Field No.");
                APIMappingLine.SetRange("Page Name", pPageID);
                APIMappingLine.SetRange("Line Type", APIMappingLine."Line Type"::Line);
                APIMappingLine.SetRange(Include, true);
                APIMappingLine.SetFilter("Service Name", '<>%1', '');
                APIMappingLine.SetRange("Is Primary", false);
                if APIMappingLine.FindSet() then begin
                    repeat
                        ltFieldRef := ltRecordRef.FIELD(APIMappingLine."Field No.");
                        if ltFieldRef.Type IN [ltFieldRef.Type::Integer, ltFieldRef.Type::Decimal, ltFieldRef.Type::Option] then begin
                            if ltFieldRef.Type = ltFieldRef.Type::Option then
                                ltFieldRef.validate(SelectOption(ltFieldRef.OptionCaption, SelectJsonTokenText(ltJsonObjectDetail, '$.' + APIMappingLine."Service Name")))
                            else
                                if SelectJsonTokenInterger(ltJsonObjectDetail, '$.' + APIMappingLine."Service Name") <> 0 then begin
                                    ltFieldRef.validate(SelectJsonTokenInterger(ltJsonObjectDetail, '$.' + APIMappingLine."Service Name"));
                                end
                        end else
                            if ltFieldRef.Type = ltFieldRef.Type::Date then begin
                                if SelectJsonTokenText(ltJsonObjectDetail, '$.' + APIMappingLine."Service Name") <> '' then begin
                                    Evaluate(ltDate, SelectJsonTokenText(ltJsonObjectDetail, '$.' + APIMappingLine."Service Name"));
                                    ltFieldRef.Validate(ltDate);
                                end;
                            end else
                                if SelectJsonTokenText(ltJsonObjectDetail, '$.' + APIMappingLine."Service Name") <> '' then
                                    ltFieldRef.Validate(SelectJsonTokenText(ltJsonObjectDetail, '$.' + APIMappingLine."Service Name"));
                    until APIMappingLine.Next() = 0;
                end;
                ltRecordRef.Modify();
                if ltJsonObjectDetail.SelectToken('$.reservelines', ltJsonTokenReserve) then
                    if subtableID = Database::"Purchase Line" then
                        PurchaseInsertReserveLine(pDocumentType, pDocumentNo, ltLineNo, ltJsonTokenReserve)
                    else
                        SalesInsertReserveLine(pDocumentType, pDocumentNo, ltLineNo, ltJsonTokenReserve);

                ltRecordRef.Close();
            end;
        end;
    end;

    local procedure DeleteDocAfterGetError(pTableID: Integer; pDocumentType: Integer; pDocumentNo: code[30])
    var
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
    begin
        if pTableID = Database::"Sales Header" then begin
            SalesHeader.reset();
            SalesHeader.SetRange("Document Type", pDocumentType);
            SalesHeader.SetRange("No.", pDocumentNo);
            if SalesHeader.FindFirst() then
                SalesHeader.Delete(true);
        end else begin
            PurchaseHeader.reset();
            PurchaseHeader.SetRange("Document Type", pDocumentType);
            PurchaseHeader.SetRange("No.", pDocumentNo);
            if PurchaseHeader.FindFirst() then
                PurchaseHeader.Delete(true);
        end;
    end;

    local procedure GetLastLine(subTableID: Integer; pDocumentType: Integer; pDocumentNo: Code[30]): Integer
    var
        SalesLine: Record "Sales Line";
        PurchaseLine: Record "Purchase Line";
    begin
        if subTableID = 37 then begin
            SalesLine.reset();
            SalesLine.SetRange("Document Type", pDocumentType);
            SalesLine.SetRange("Document No.", pDocumentNo);
            if SalesLine.FindLast() then
                exit(SalesLine."Line No." + 10000);
            exiT(10000);
        end else begin
            PurchaseLine.reset();
            PurchaseLine.SetRange("Document Type", pDocumentType);
            PurchaseLine.SetRange("Document No.", pDocumentNo);
            if PurchaseLine.FindLast() then
                exit(PurchaseLine."Line No." + 10000);
            exiT(10000);
        end;
    end;

    local procedure SelectOption(pOptionCaption: Text; pValue: Text): integer
    var
        ltLoopOption: Integer;
    begin
        pOptionCaption := pOptionCaption + ',,,,,,,,,,';
        for ltLoopOption := 1 TO 10 do begin
            if UPPERCASE(SelectStr(ltLoopOption, pOptionCaption)) = uppercase(pValue) then
                exit(ltLoopOption - 1);
        end;
    end;

    local procedure InsertTOTempReserve(var pTempReservEntry: Record "Reservation Entry" temporary; pJsonToken: JsonToken)
    var
        ltJsonTokenReserve: JsonToken;
        ltJsonArray: JsonArray;
        ltJsonObject: JsonObject;
        ltLineNo: Integer;
    begin
        CLEAR(ltJsonObject);
        Clear(ltJsonTokenReserve);
        CLEAR(ltJsonArray);
        pTempReservEntry.reset();
        pTempReservEntry.DeleteAll();
        ltJsonArray := pJsonToken.AsArray();
        foreach ltJsonTokenReserve in ltJsonArray do begin
            ltJsonObject := ltJsonTokenReserve.AsObject();
            ltLineNo := ltLineNo + 1;
            pTempReservEntry.init();
            pTempReservEntry."Entry No." := ltLineNo;
            pTempReservEntry.Quantity := SelectJsonTokenInterger(ltJsonObject, '$.quantity');
            pTempReservEntry."Lot No." := SelectJsonTokenText(ltJsonObject, '$.lotno');
            pTempReservEntry."Serial No." := SelectJsonTokenText(ltJsonObject, '$.serialno');
            pTempReservEntry."Expiration Date" := Today();
            pTempReservEntry.Insert();
        end;
    end;

    local procedure PurchaseInsertReserveLine(pDocumentType: Integer; pDocumentNo: Code[30];
                                                                 pLineNo: Integer;
                                                                 pJsonToken: JsonToken)
    var
        ltItem: Record Item;
        TempReservEntry: Record "Reservation Entry" temporary;
        PurchLine: Record "Purchase Line";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ReservStatus: Enum "Reservation Status";
    begin
        PurchLine.GET(pDocumentType, pDocumentNo, pLineNo);
        if (PurchLine."No." <> '') and (PurchLine.Type = PurchLine.Type::Item) then begin
            ltItem.GET(PurchLine."No.");
            if ltItem."Item Tracking Code" <> '' then begin
                InsertTOTempReserve(TempReservEntry, pJsonToken);
                TempReservEntry.reset();
                if TempReservEntry.FindSet() then
                    repeat
                        CreateReservEntry.SetDates(0D, TempReservEntry."Expiration Date");
                        CreateReservEntry.CreateReservEntryFor(
                          Database::"Purchase Line", PurchLine."Document Type".AsInteger(),
                          PurchLine."Document No.", '', 0, PurchLine."Line No.", PurchLine."Qty. per Unit of Measure",
                          TempReservEntry.Quantity, TempReservEntry.Quantity * PurchLine."Qty. per Unit of Measure", TempReservEntry);
                        CreateReservEntry.CreateEntry(
                          PurchLine."No.", PurchLine."Variant Code", PurchLine."Location Code", '', PurchLine."Expected Receipt Date", 0D, 0, ReservStatus::Surplus);
                    until TempReservEntry.Next() = 0;
            end;
        end;
    end;

    local procedure SalesInsertReserveLine(pDocumentType: Integer; pDocumentNo: Code[30];
                                                              pLineNo: Integer;
                                                              pJsonToken: JsonToken)
    var
        ltItem: Record Item;
        TempReservEntry: Record "Reservation Entry" temporary;
        SalesLine: Record "Sales Line";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ReservStatus: Enum "Reservation Status";
    begin
        TempReservEntry.reset();
        TempReservEntry.DeleteAll();
        SalesLine.GET(pDocumentType, pDocumentNo, pLineNo);
        if (SalesLine."No." <> '') and (SalesLine.Type = SalesLine.Type::Item) then begin
            ltItem.GET(SalesLine."No.");
            if ltItem."Item Tracking Code" <> '' then begin
                InsertTOTempReserve(TempReservEntry, pJsonToken);
                TempReservEntry.reset();
                if TempReservEntry.FindSet() then
                    repeat
                        CreateReservEntry.SetDates(0D, TempReservEntry."Expiration Date");
                        CreateReservEntry.CreateReservEntryFor(
                          Database::"Sales Line", SalesLine."Document Type".AsInteger(),
                          SalesLine."Document No.", '', 0, SalesLine."Line No.", SalesLine."Qty. per Unit of Measure",
                          TempReservEntry.Quantity, TempReservEntry.Quantity * SalesLine."Qty. per Unit of Measure", TempReservEntry);
                        CreateReservEntry.CreateEntry(
                          SalesLine."No.", SalesLine."Variant Code", SalesLine."Location Code", '', 0D, 0D, 0, ReservStatus::Surplus);
                    until TempReservEntry.Next() = 0;
            end;
        end;
    end;


    local procedure ItemJournalInsertReserveLine(pJournalTemplate: Code[30]; pBatchName: Code[30]; pLineNo: Integer; pJsonToken: JsonToken)
    var
        ltItem: Record Item;
        TempReservEntry: Record "Reservation Entry" temporary;
        itemJournal: Record "Item Journal Line";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ReservStatus: Enum "Reservation Status";

    begin
        TempReservEntry.reset();
        TempReservEntry.DeleteAll();
        itemJournal.GET(pJournalTemplate, pBatchName, pLineNo);
        if (itemJournal."Item No." <> '') then begin
            ltItem.GET(itemJournal."Item No.");
            if ltItem."Item Tracking Code" <> '' then begin
                InsertTOTempReserve(TempReservEntry, pJsonToken);
                TempReservEntry.reset();
                if TempReservEntry.FindSet() then
                    repeat
                        CreateReservEntry.SetDates(0D, TempReservEntry."Expiration Date");
                        //If itemJournal."Entry Type" = itemJournal."Entry Type"::Transfer then //movement
                        //   CreateReservEntry.SetNewSerialLotNo(TempReservEntry."Serial No.", TempReservEntry."Lot No.");
                        CreateReservEntry.CreateReservEntryFor(
                          Database::"Item Journal Line", itemJournal."Entry Type".AsInteger(),
                          itemJournal."Journal Template Name", itemJournal."Journal Batch Name", 0, itemJournal."Line No.", itemJournal."Qty. per Unit of Measure",
                          TempReservEntry.Quantity, TempReservEntry.Quantity * itemJournal."Qty. per Unit of Measure", TempReservEntry);
                        CreateReservEntry.CreateEntry(
                          itemJournal."Item No.", itemJournal."Variant Code", itemJournal."Location Code", '', 0D, 0D, 0, ReservStatus::Surplus);
                    until TempReservEntry.Next() = 0;
            end;
        end;
    end;

    local procedure GetNoOfAPI(pPageName: Text): Integer;
    var
        apiLog: Record "FK API Log";
    begin
        apiLog.reset();
        apiLog.SetCurrentKey("Page Name", "No. of API");
        apiLog.SetRange("Page Name", pPageName);
        if apiLog.FindLast() then
            exit(apiLog."No. of API" + 1);
        exit(1);
    end;

    local procedure insertlog(pTableID: integer; PageName: text; pjsonObject: JsonObject; pDateTime: DateTime; pMsgError: Text; pStatus: Option Successfully,"Error"; pNoOfAPI: Integer; pMsgErrorCode: text; pDocumentNo: Code[30]; pMethodType: Option "Insert","Update","Delete")
    var
        apiLog: Record "FK API Log";
        JsonText: Text;
        ltOutStream: OutStream;
    begin
        JsonText := '';
        pjsonObject.WriteTo(JsonText);
        apiLog.Init();
        apiLog."Entry No." := GetLastEntryLog();
        apiLog."Page Name" := PageName;
        apiLog."No." := pTableID;
        apiLog."Date Time" := pDateTime;
        apiLog."Last Error" := copystr(pMsgError, 1, 2047);
        apiLog.Status := pStatus;
        apiLog."No. of API" := pNoOfAPI;
        apiLog."Method Type" := pMethodType;
        apiLog."Interface By" := CopyStr(USERID(), 1, 100);
        apiLog.Insert(true);
        apiLog."Json Msg.".CreateOutStream(ltOutStream, TEXTENCODING::UTF8);
        apiLog."Last Error Code" := pMsgErrorCode;
        apiLog."Document No." := pDocumentNo;
        ltOutStream.WriteText(JsonText);
        apiLog.Modify();
    end;

    local procedure GetLastEntryLog(): Integer
    var
        apiLog: Record "FK API Log";
    begin
        apiLog.reset();
        apiLog.SetCurrentKey("Entry No.");
        if apiLog.FindLast() then
            exit(apiLog."Entry No." + 1);
        exit(1);
    end;

    local procedure ReuturnErrorAPI(pPageName: Text; pNoOfAPI: Integer): Text
    var
        apiLog: Record "FK API Log";
        pJsonObject, pJsonObjectBuill : JsonObject;
        pJsonArray: JsonArray;
        ltReturnText: Text;
    begin
        ltReturnText := '';
        CLEAR(pJsonObject);
        CLEAR(pJsonArray);
        CLEAR(pJsonObjectBuill);
        apiLog.reset();
        apiLog.SetRange("Page Name", pPageName);
        apiLog.SetRange("No. of API", pNoOfAPI);
        apiLog.SetRange(Status, apiLog.Status::Error);
        if apiLog.FindSet() then begin
            repeat
                CLEAR(pJsonObject);
                pJsonObject.Add('page', apiLog."Page Name");
                pJsonObject.Add('tableID', apiLog."No.");
                pJsonObject.Add('dateTime', apiLog."Date Time");
                pJsonObject.Add('lastError', apiLog."Last Error");
                pJsonArray.Add(pJsonObject);
            until apiLog.Next() = 0;
            pJsonObjectBuill.Add('status', 'Error');
            pJsonObjectBuill.Add('total', apiLog.Count);
            pJsonObjectBuill.Add('detail', pJsonArray);
            pJsonObjectBuill.WriteTo(ltReturnText);
        end else begin
            pJsonObjectBuill.Add('status', 'Successfully');
            pJsonObjectBuill.WriteTo(ltReturnText);
        end;
        exit(ltReturnText);
    end;



    /// <summary>
    /// ExportJsonFormatMuntitable.
    /// </summary>
    /// <param name="pPageNO">Integer.</param>
    /// <param name="pPageNOSubform">Integer.</param>
    /// <param name="pDocumentType">Enum "Sales Document Type".</param>
    /// <param name="pApiName">Text.</param>
    /// <param name="pPageName">Integer.</param>
    /// <param name="pTableID">Integer.</param>
    /// <param name="pSubTableID">Integer.</param>
    /// <param name="pDocumentNo">Text.</param>
    /// <param name="pJsonFormat">Boolean.</param>
    procedure ExportJsonFormatMultitable(pPageNO: Integer; pPageNOSubform: Integer; pDocumentType: Enum "Sales Document Type"; pApiName: Text;
                                                                                                       pPageName: Integer;
                                                                                                       pTableID: Integer;
                                                                                                       pSubTableID: Integer;
                                                                                                       pDocumentNo: Text;
                                                                                                       pJsonFormat: Boolean)
    var
        //  PageControl, PageControlDetail : Record "Page Control Field";
        APIMapping, APIMappingLine : Record "API Setup Line";
        ReservationEntry: Record "Reservation Entry";
        ltField: Record Field;
        ltJsonObject, ltResult, ltJsonObjectbuill, ltJsonObjectbuillReserve, ltJsonObjectReserve : JsonObject;
        ltJsonArray, ltJsonArraybuill, ltJsonArrayReserve : JsonArray;
        ltFieldRef: FieldRef;
        ltRecordRef: RecordRef;
        ltText: Text;
        tempBlob: Codeunit "Temp Blob";
        ltOutStr: OutStream;
        ltInstr: InStream;
        ltFileName: Text;
        ValueDecimal: Decimal;
        ValueInteger, ltLineNo : Integer;
        documentNo: Code[20];
        CR, LF, tab : char;
        CheckFirstLine: Text;
        CheckFirstLineInt, CheckFirstLineInt2 : Integer;
    begin
        CLEAR(ltFieldRef);
        CLEAR(ltJsonObject);
        CLEAR(ltJsonObjectbuill);
        CLEAR(ltJsonArrayReserve);
        CLEAR(ltJsonObjectReserve);
        ltRecordRef.Open(pTableID);
        ltFieldRef := ltRecordRef.FieldIndex(1);
        ltFieldRef.SetRange(pDocumentType);
        if pDocumentNo <> '' then begin
            ltFieldRef := ltRecordRef.FieldIndex(2);
            ltFieldRef.SetFilter(pDocumentNo);
        end;
        if ltRecordRef.FindFirst() then begin
            ltFieldRef := ltRecordRef.FieldIndex(2);
            documentNo := format(ltFieldRef.Value);
            CheckFirstLineInt := 0;
            APIMappingLine.reset();
            APIMappingLine.SetCurrentKey("Page Name", "Line Type", "Field No.");
            APIMappingLine.SetRange("Page Name", pPageName);
            APIMappingLine.SetRange("Line Type", APIMappingLine."Line Type"::Header);
            APIMappingLine.SetRange(Include, true);
            APIMappingLine.SetFilter("Service Name", '<>%1', '');
            if APIMappingLine.FindSet() then begin
                repeat
                    ltField.GET(pTableID, APIMappingLine."Field No.");
                    if (ltField.Class = ltField.Class::Normal) and (ltField.Type <> ltField.Type::BLOB) then begin
                        ltFieldRef := ltRecordRef.Field(ltField."No.");
                        if ltField.Type in [ltField.Type::Decimal, ltField.Type::Integer] then begin
                            if ltField.Type = ltField.Type::Integer then begin
                                Evaluate(ValueInteger, format(ltFieldRef.Value));
                                if ltJsonObjectbuill.Add(APIMappingLine."Service Name", ValueInteger) then;
                            end else begin
                                Evaluate(ValueDecimal, format(ltFieldRef.Value));
                                if ltJsonObjectbuill.Add(APIMappingLine."Service Name", ValueDecimal) then;
                            end;
                        end else
                            if ltJsonObjectbuill.Add(APIMappingLine."Service Name", format(ltFieldRef.Value)) then;
                    end;

                until APIMappingLine.Next() = 0;
            end;
            ltRecordRef.Close();

            CLEAR(ltJsonArray);
            CLEAR(ltFieldRef);
            CheckFirstLineInt := 0;
            CheckFirstLineInt2 := 0;
            ltRecordRef.Open(pSubTableID);
            ltFieldRef := ltRecordRef.FieldIndex(1);
            ltFieldRef.SetRange(pDocumentType);
            ltFieldRef := ltRecordRef.FieldIndex(2);
            ltFieldRef.SetRange(documentNo);
            if ltRecordRef.FindFirst() then begin
                repeat
                    CheckFirstLineInt2 := CheckFirstLineInt2 + 1;
                    CLEAR(ltJsonObject);
                    APIMappingLine.reset();
                    APIMappingLine.SetCurrentKey("Page Name", "Line Type", "Field No.");
                    APIMappingLine.SetRange("Page Name", pPageName);
                    APIMappingLine.SetRange("Line Type", APIMappingLine."Line Type"::Line);
                    APIMappingLine.SetRange(Include, true);
                    APIMappingLine.SetFilter("Service Name", '<>%1', '');
                    if APIMappingLine.FindSet() then
                        repeat

                            ltField.GET(pSubTableID, APIMappingLine."Field No.");
                            if (ltField.Class = ltField.Class::Normal) and (ltField.Type <> ltField.Type::BLOB) then begin
                                CheckFirstLineInt := CheckFirstLineInt + 1;
                                CheckFirstLine := '';
                                if CheckFirstLineInt2 = 1 then begin
                                    if CheckFirstLineInt > 1 then
                                        CheckFirstLine := '@'
                                end else
                                    CheckFirstLine := '?';
                                ltFieldRef := ltRecordRef.Field(ltField."No.");
                                if ltField.Type in [ltField.Type::Decimal, ltField.Type::Integer] then begin
                                    if ltField.Type = ltField.Type::Integer then begin
                                        Evaluate(ValueInteger, format(ltFieldRef.Value));
                                        if ltJsonObject.Add(CheckFirstLine + APIMappingLine."Service Name", ValueInteger) then;
                                    end else begin
                                        Evaluate(ValueDecimal, format(ltFieldRef.Value));
                                        if ltJsonObject.Add(CheckFirstLine + APIMappingLine."Service Name", ValueDecimal) then;
                                    end;
                                end else
                                    if ltJsonObject.Add(CheckFirstLine + APIMappingLine."Service Name", format(ltFieldRef.Value)) then;
                            end;

                        until APIMappingLine.Next() = 0;
                    CLEAR(ltJsonObjectReserve);
                    CLEAR(ltJsonArrayReserve);
                    CheckFirstLineInt := 0;
                    ltFieldRef := ltRecordRef.FieldIndex(3);
                    Evaluate(ltLineNo, format(ltFieldRef.Value));
                    ReservationEntry.reset();
                    ReservationEntry.SetRange("Source ID", documentNo);
                    ReservationEntry.SetRange("Source Ref. No.", ltLineNo);
                    if ReservationEntry.FindSet() then begin
                        repeat
                            CheckFirstLineInt := CheckFirstLineInt + 1;
                            CLEAR(ltJsonObjectReserve);
                            if CheckFirstLineInt = 1 then begin
                                ltJsonObjectReserve.Add('quantity', ReservationEntry.Quantity);
                                ltJsonObjectReserve.Add('$lotno', ReservationEntry."Lot No.");
                                ltJsonObjectReserve.Add('$serialno', ReservationEntry."Serial No.");
                            end else begin
                                ltJsonObjectReserve.Add('$quantity', ReservationEntry.Quantity);
                                ltJsonObjectReserve.Add('$lotno', ReservationEntry."Lot No.");
                                ltJsonObjectReserve.Add('$serialno', ReservationEntry."Serial No.");
                            end;
                            ltJsonArrayReserve.Add(ltJsonObjectReserve);
                        until ReservationEntry.Next() = 0;
                        ltJsonObject.Add('?reservelines', ltJsonArrayReserve);
                    end;
                    ltJsonArray.Add(ltJsonObject);
                until ltRecordRef.next = 0;

                ltRecordRef.Close();
            end;
        end;
        ltJsonObjectbuill.Add('detaillines', ltJsonArray);
        ltJsonArraybuill.Add(ltJsonObjectbuill);

        ltResult.Add(pApiName, ltJsonArraybuill);
        ltResult.WriteTo(ltText);
        if not pJsonFormat then begin
            CR := 13;
            LF := 10;
            tab := 09;
            ltText := ltText.Replace('"', '\"');
            ltText := ltText.Replace(',', ',' + format(CR) + Format(lf) + format(tab) + format(tab) + format(tab) + format(tab));
            ltText := ltText.Replace('\"@', format(tab) + format(tab) + format(tab) + '\"');
            ltText := ltText.Replace('{\"?', format(tab) + format(tab) + format(tab) + '{\"');
            ltText := ltText.Replace('\"?', format(tab) + format(tab) + format(tab) + '\"');
            ltText := ltText.Replace('{\"$', format(tab) + format(tab) + format(tab) + format(tab) + format(tab) + format(tab) + '{\"');
            ltText := ltText.Replace('\"$', format(tab) + format(tab) + format(tab) + format(tab) + format(tab) + format(tab) + '\"');
            ltText := ltText.Replace('\"' + pApiName + '\":', '"' + pApiName + '":"');
            ltText := COPYSTR(ltText, 1, StrLen(ltText) - 1) + '"' + format(CR) + Format(lf) + '}';
        end;
        tempBlob.CreateOutStream(ltOutStr, TextEncoding::UTF8);
        ltOutStr.WriteText(ltText);
        tempBlob.CreateInStream(ltInstr, TextEncoding::UTF8);
        ltFileName := 'API_' + pApiName + '.txt';
        DownloadFromStream(ltInstr, 'Export', '', '', ltFileName)

    end;


    /// <summary>
    /// ExportJsonFormat.
    /// </summary>
    /// <param name="pPageNO">Integer.</param>
    /// <param name="pTableID">Integer.</param>
    /// <param name="pApiName">Text.</param>
    /// <param name="pPageName">Integer.</param>
    /// <param name="pDocumentNo">Text.</param>
    /// <param name="pJsonFormat">Boolean.</param>
    procedure ExportJsonFormat(pPageNO: Integer;
                pTableID: Integer;
                pApiName: Text;
                pPageName: Enum "FK Api Page Type";
                               pDocumentNo: Text;
                               pJsonFormat: Boolean)
    var

        APIMappingLine: Record "API Setup Line";
        ReservationEntry: Record "Reservation Entry";
        ltField: Record Field;
        ltJsonObject, ltJsonObjectReserve, ltResult : JsonObject;
        ltJsonArray, ltJsonArrayReserve : JsonArray;
        ltFieldRef: FieldRef;
        ltRecordRef: RecordRef;
        ltText: Text;
        tempBlob: Codeunit "Temp Blob";
        ltOutStr: OutStream;
        ltInstr: InStream;
        ltFileName: Text;
        ValueDecimal: Decimal;
        ValueInteger, ltLineNo : Integer;
        TemplateName, BatchName : Code[30];
        CR, LF, tab : char;
        CheckFirstLineInt: Integer;
    begin
        if pDocumentNo = '' then
            ERROR('Document no. fillter must specifies');
        ltRecordRef.Open(pTableID);
        if not (pTableID in [Database::"Gen. Journal Line", Database::"Item Journal Line"]) then
            if pApiName in ['goodreceiptnotelists', 'returnreceiptlists'] then
                ltFieldRef := ltRecordRef.FieldIndex(2)
            else
                ltFieldRef := ltRecordRef.FieldIndex(1)
        else
            ltFieldRef := ltRecordRef.Field(7);
        ltFieldRef.SetFilter(pDocumentNo);
        if ltRecordRef.FindFirst() then begin
            repeat
                CLEAR(ltJsonObject);
                APIMappingLine.reset();
                APIMappingLine.SetCurrentKey("Page Name", "Line Type", "Field No.");
                APIMappingLine.SetRange("Page Name", pPageName);
                APIMappingLine.SetRange("Line Type", APIMappingLine."Line Type"::Header);
                APIMappingLine.SetRange(Include, true);
                APIMappingLine.SetFilter("Service Name", '<>%1', '');
                if APIMappingLine.FindSet() then begin
                    repeat
                        ltField.GET(pTableID, APIMappingLine."Field No.");
                        if (ltField.Class = ltField.Class::Normal) and (ltField.Type <> ltField.Type::BLOB) then begin
                            ltFieldRef := ltRecordRef.Field(ltField."No.");
                            if ltField.Type in [ltField.Type::Decimal, ltField.Type::Integer] then begin
                                if ltField.Type = ltField.Type::Integer then begin
                                    Evaluate(ValueInteger, format(ltFieldRef.Value));
                                    if ltJsonObject.Add(APIMappingLine."Service Name", ValueInteger) then;
                                end else begin
                                    Evaluate(ValueDecimal, format(ltFieldRef.Value));
                                    if ltJsonObject.Add(APIMappingLine."Service Name", ValueDecimal) then;
                                end;
                            end else
                                if ltJsonObject.Add(APIMappingLine."Service Name", format(ltFieldRef.Value)) then;
                        end;

                    until APIMappingLine.Next() = 0;
                    ltJsonArray.Add(ltJsonObject);
                end;
                CheckFirstLineInt := 0;
                if pTableID = Database::Customer then begin
                    CLEAR(ltJsonArrayReserve);
                    CLEAR(ltJsonObjectReserve);
                    APIMappingLine.reset();
                    APIMappingLine.SetCurrentKey("Page Name", "Line Type", "Field No.");
                    APIMappingLine.SetRange("Page Name", pPageName);
                    APIMappingLine.SetRange("Line Type", APIMappingLine."Line Type"::Line);
                    APIMappingLine.SetRange(Include, true);
                    APIMappingLine.SetFilter("Service Name", '<>%1', '');
                    if APIMappingLine.FindFirst() then begin
                        repeat
                            CheckFirstLineInt := CheckFirstLineInt + 1;
                            if CheckFirstLineInt = 1 then
                                ltJsonObjectReserve.Add(APIMappingLine."Service Name", 'Value' + APIMappingLine."Service Name")
                            else
                                ltJsonObjectReserve.Add('$' + APIMappingLine."Service Name", 'Value' + APIMappingLine."Service Name");
                        until APIMappingLine.next = 0;
                        ltJsonArrayReserve.Add(ltJsonObjectReserve);
                    end;
                    ltJsonObject.Add('?shiptodetail', ltJsonArrayReserve);
                end;


            until ltRecordRef.Next() = 0;
        end;
        ltRecordRef.Close();
        ltResult.Add(pApiName, ltJsonArray);
        ltResult.WriteTo(ltText);
        if not pJsonFormat then begin
            CR := 13;
            LF := 10;
            tab := 09;
            ltText := ltText.Replace('"', '\"');
            ltText := ltText.Replace(',', ',' + format(CR) + Format(lf) + format(tab) + format(tab) + format(tab));
            ltText := ltText.Replace('\"?', format(tab) + format(tab) + format(tab) + '\"');
            ltText := ltText.Replace('{\"$', format(tab) + format(tab) + format(tab) + format(tab) + format(tab) + format(tab) + '{\"');
            ltText := ltText.Replace('\"$', format(tab) + format(tab) + format(tab) + format(tab) + format(tab) + format(tab) + '\"');
            ltText := ltText.Replace('\"' + pApiName + '\":', '"' + pApiName + '":"');
            ltText := COPYSTR(ltText, 1, StrLen(ltText) - 1) + '"' + format(CR) + Format(lf) + '}';
        end;
        tempBlob.CreateOutStream(ltOutStr, TextEncoding::UTF8);
        ltOutStr.WriteText(ltText);
        tempBlob.CreateInStream(ltInstr, TextEncoding::UTF8);
        ltFileName := 'API_' + pApiName + '.txt';
        DownloadFromStream(ltInstr, 'Export', '', '', ltFileName)
    end;

    local procedure SelectJsonTokenText(JsonObject: JsonObject; Path: text): text;
    var
        ltJsonToken: JsonToken;
        lJObjProduct: JsonObject;
        lJArrSku: JsonArray;
        ImageText: Text;
    begin
        if not JsonObject.SelectToken(Path, ltJsonToken) then
            exit('');
        if ltJsonToken.AsValue.IsNull then
            exit('');
        exit(ltJsonToken.asvalue.astext());
    end;

    local procedure SelectJsonTokenInterger(JsonObject: JsonObject; Path: text): Decimal;
    var
        ltJsonToken: JsonToken;
        ConvertTextToDecimal: Decimal;
        DecimalText: Text;
    begin
        if not JsonObject.SelectToken(Path, ltJsonToken) then
            exit(0);
        if ltJsonToken.AsValue.IsNull then
            exit(0);
        DecimalText := delchr(format(ltJsonToken), '=', '"');
        if DecimalText = '' then
            DecimalText := '0';
        Evaluate(ConvertTextToDecimal, DecimalText);
        exit(ConvertTextToDecimal);
    end;


    local procedure ConnectToWebService(pJsonBody: Text; pBaseUrl: text)
    var
        gvHttpHeadersContent: HttpHeaders;
        gvHttpRequestMessage: HttpRequestMessage;
        gvHttpResponseMessage: HttpResponseMessage;
        gvHttpClient: HttpClient;

        gvHttpContent, gvHttpContentaddboydy : HttpContent;
        PayloadOutStream: OutStream;
        PayloadInStream: InStream;
        ltJsonToken: JsonToken;
        ltJsonObject: JsonObject;
        gvResponseText: Text;
    begin
        if (pJsonBody = '') or (pBaseUrl = '') then
            exit;
        CLEAR(gvHttpRequestMessage);
        CLEAR(gvHttpClient);
        CLEAR(gvHttpResponseMessage);
        CLEAR(gvResponseText);
        CLEAR(gvHttpContent);
        CLEAR(gvHttpContentaddboydy);

        gvHttpContentaddboydy.WriteFrom(pJsonBody);
        gvHttpContentaddboydy.GetHeaders(gvHttpHeadersContent);
        gvHttpHeadersContent.Clear();
        gvHttpHeadersContent.Add('Content-Type', 'application/json');
        gvHttpRequestMessage.Content := gvHttpContentaddboydy;
        gvHttpRequestMessage.SetRequestUri(pBaseUrl);
        gvHttpRequestMessage.Method := 'POST';
        gvHttpClient.Send(gvHttpRequestMessage, gvHttpResponseMessage);
        gvHttpResponseMessage.Content.ReadAs(gvResponseText);
        if (gvHttpResponseMessage.IsSuccessStatusCode()) then begin
            ltJsonToken.ReadFrom(gvResponseText);
            ltJsonObject := ltJsonToken.AsObject();
        end else
            ERROR(gvResponseText);
    end;

    var
        gvNo: Text;
}