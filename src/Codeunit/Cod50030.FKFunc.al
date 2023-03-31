/// <summary>
/// Codeunit FK Func (ID 50030).
/// </summary>
codeunit 50030 "FK Func"
{
    /// <summary>
    /// CreateCustomer.
    /// </summary>
    /// <param name="customerlists">BigText.</param>
    /// <returns>Return value of type Text.</returns>
    procedure CreateCustomer(customerlists: BigText): Text;
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
                Insertlog(Database::Customer, ltPageName, ltJsonObject2, ltDateTime, GetLastErrorText(), 1, ltNoofAPI)
            else
                Insertlog(Database::Customer, ltPageName, ltJsonObject2, ltDateTime, '', 0, ltNoofAPI);

        end;
        exit(ReuturnErrorAPI(ltPageName, ltNoofAPI));
    end;

    procedure CreateItem(itemlists: BigText): Text;
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
                Insertlog(Database::Item, ltPageName, ltJsonObject2, ltDateTime, GetLastErrorText(), 1, ltNoofAPI)
            else
                Insertlog(Database::Item, ltPageName, ltJsonObject2, ltDateTime, '', 0, ltNoofAPI);
        end;
        exit(ReuturnErrorAPI(ltPageName, ltNoofAPI));
    end;

    procedure CreateVendor(vendorlists: BigText): Text;
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
            if not InsertTotable(3, Database::Item, ltJsonObject2) then
                Insertlog(Database::Vendor, ltPageName, ltJsonObject2, ltDateTime, GetLastErrorText(), 1, ltNoofAPI)
            else
                Insertlog(Database::Vendor, ltPageName, ltJsonObject2, ltDateTime, '', 0, ltNoofAPI);
        end;
        exit(ReuturnErrorAPI(ltPageName, ltNoofAPI));
    end;



    [TryFunction]
    local procedure InsertTotable(pPageName: Option; pTableID: Integer; pJsonObject: JsonObject)
    var
        APIMappingHeader: Record "API Setup Header";
        APIMappingLine: Record "API Setup Line";
        ltFieldRef: FieldRef;
        ltRecordRef: RecordRef;
        ltField: Record Field;

    begin
        APIMappingHeader.GET(pPageName);
        ltRecordRef.Open(APIMappingHeader."Table ID");
        ltRecordRef.Init();
        APIMappingLine.reset();
        APIMappingLine.SetRange("Page Name", APIMappingHeader."Page Name");
        APIMappingLine.SetRange("Line Type", APIMappingLine."Line Type"::Header);
        APIMappingLine.SetRange(Include, true);
        APIMappingLine.SetFilter("Service Name", '<>%1', '');
        APIMappingLine.SetRange("Is Primary", true);
        if APIMappingLine.FindSet() then
            repeat
                ltFieldRef := ltRecordRef.FIELD(APIMappingLine."Field No.");
                if UpperCase(format(ltFieldRef.Type)) IN ['CODE', 'TEXT'] then
                    ltFieldRef.Validate(SelectJsonTokenText(pJsonObject, '$.' + APIMappingLine."Service Name"));
                if UpperCase(format(ltFieldRef.Type)) IN ['INTEGER', 'DECIMAL', 'BIGINTEGER'] then
                    ltFieldRef.validate(SelectJsonTokenInterger(pJsonObject, '$.' + APIMappingLine."Service Name"));
            until APIMappingLine.Next() = 0;
        ltRecordRef.Insert(true);
        APIMappingLine.SetRange("Is Primary", false);
        if APIMappingLine.FindSet() then begin
            repeat
                ltFieldRef := ltRecordRef.FIELD(APIMappingLine."Field No.");
                if UpperCase(format(ltFieldRef.Type)) IN ['CODE', 'TEXT'] then
                    ltFieldRef.Validate(SelectJsonTokenText(pJsonObject, '$.' + APIMappingLine."Service Name"));
                if UpperCase(format(ltFieldRef.Type)) IN ['INTEGER', 'DECIMAL', 'BIGINTEGER'] then
                    ltFieldRef.validate(SelectJsonTokenInterger(pJsonObject, '$.' + APIMappingLine."Service Name"));
            until APIMappingLine.Next() = 0;
            ltRecordRef.Modify(true);
        end;
        ltRecordRef.Close();

        IF APIMappingHeader."Sub Table ID" <> 0 then
            InsertTotableLine(pJsonObject, APIMappingHeader."Sub Table ID", APIMappingHeader."Page Name", APIMappingHeader."Sub Page No.");
    end;

    local procedure InsertTotableLine(pJsonObject: JsonObject; subtableID: Integer; pPageID: Integer; pSubPageID: Integer)
    var
        ltJsonObject, ltJsonObjectDetail : JsonObject;
        APIMappingLine: Record "API Setup Line";
        ltJsonToken: JsonToken;
        ltJsonArray: JsonArray;
        ltJsonTokenDetail, ltJsonTokenReserve : JsonToken;
        ltFieldRef: FieldRef;
        ltRecordRef: RecordRef;
        ltField: Record Field;
    begin
        if ltJsonObject.SelectToken('$.detail', ltJsonToken) then begin
            ltJsonArray := ltJsonToken.AsArray();
            foreach ltJsonTokenDetail in ltJsonArray do begin
                ltJsonObjectDetail := ltJsonTokenDetail.AsObject();
                ltRecordRef.Open(subtableID);
                ltRecordRef.Init();
                APIMappingLine.reset();
                APIMappingLine.SetRange("Page Name", pPageID);
                APIMappingLine.SetRange("Line Type", APIMappingLine."Line Type"::Line);
                APIMappingLine.SetRange(Include, true);
                APIMappingLine.SetFilter("Service Name", '<>%1', '');
                APIMappingLine.SetRange("Is Primary", true);
                if APIMappingLine.FindSet() then
                    repeat
                        ltFieldRef := ltRecordRef.FIELD(APIMappingLine."Field No.");
                        if UpperCase(format(ltFieldRef.Type)) IN ['CODE', 'TEXT'] then
                            ltFieldRef.Validate(SelectJsonTokenText(pJsonObject, '$.' + APIMappingLine."Service Name"));
                        if UpperCase(format(ltFieldRef.Type)) IN ['INTEGER', 'DECIMAL', 'BIGINTEGER'] then
                            ltFieldRef.validate(SelectJsonTokenInterger(pJsonObject, '$.' + APIMappingLine."Service Name"));
                    until APIMappingLine.Next() = 0;
                ltRecordRef.Insert(true);
                APIMappingLine.SetRange("Is Primary", false);
                if APIMappingLine.FindSet() then begin
                    repeat
                        ltFieldRef := ltRecordRef.FIELD(APIMappingLine."Field No.");
                        if UpperCase(format(ltFieldRef.Type)) IN ['CODE', 'TEXT'] then
                            ltFieldRef.Validate(SelectJsonTokenText(pJsonObject, '$.' + APIMappingLine."Service Name"));
                        if UpperCase(format(ltFieldRef.Type)) IN ['INTEGER', 'DECIMAL', 'BIGINTEGER'] then
                            ltFieldRef.validate(SelectJsonTokenInterger(pJsonObject, '$.' + APIMappingLine."Service Name"));
                    until APIMappingLine.Next() = 0;
                    ltRecordRef.Modify(true);
                end;
                ltRecordRef.Modify(true);

                // if ltJsonObjectDetail.SelectToken('$.reservelines', ltJsonTokenReserve) then
                //     InsertReserve();
            end;
        end;
    end;

    local procedure InsertReserve(pDocumentNo: Code[30]; pLineNo: Integer; pTableID: Integer)
    begin

    end;

    local procedure GetNoOfAPI(pPageName: Text): Integer;
    var
        apiLog: Record "API Log";
    begin
        apiLog.reset();
        apiLog.SetCurrentKey("Page Name", "No. of API");
        apiLog.SetRange("Page Name", pPageName);
        if apiLog.FindLast() then
            exit(apiLog."No. of API" + 1);
        exit(1);
    end;

    local procedure insertlog(pTableID: integer; PageName: text; pjsonObject: JsonObject; pDateTime: DateTime; pMsgError: Text; pStatus: Option Successfully,"Error"; pNoOfAPI: Integer)
    var
        apiLog: Record "API Log";
        JsonText: Text;
    begin
        JsonText := '';
        pjsonObject.WriteTo(JsonText);
        apiLog.Init();
        apiLog."Entry No." := GetLastEntryLog();
        apiLog."Page Name" := PageName;
        apiLog."No." := pTableID;
        apiLog."Date Time" := pDateTime;
        apiLog."Json Msg." := copystr(JsonText, 1, 2047);
        apiLog."Last Error" := copystr(pMsgError, 1, 2047);
        apiLog.Status := pStatus;
        apiLog."No. of API" := pNoOfAPI;
        apiLog.Insert(true);
    end;

    local procedure GetLastEntryLog(): Integer
    var
        apiLog: Record "API Log";
    begin
        apiLog.reset();
        apiLog.SetCurrentKey("Entry No.");
        if apiLog.FindLast() then
            exit(apiLog."Entry No." + 1);
        exit(1);
    end;

    local procedure ReuturnErrorAPI(pPageName: Text; pNoOfAPI: Integer): Text
    var
        apiLog: Record "API Log";
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
    procedure ExportJsonFormatMuntitable(pPageNO: Integer; pPageNOSubform: Integer; pDocumentType: Enum "Sales Document Type"; pApiName: Text;
                                                                                                       pPageName: Integer;
                                                                                                       pTableID: Integer;
                                                                                                       pSubTableID: Integer;
                                                                                                       pDocumentNo: Text)
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
                                if ltJsonObjectbuill.Add(DelChr(LowerCase(ltField.FieldName), '=', '_-&%(). '), ValueInteger) then;
                            end else begin
                                Evaluate(ValueDecimal, format(ltFieldRef.Value));
                                if ltJsonObjectbuill.Add(DelChr(LowerCase(ltField.FieldName), '=', '_-&%(). '), ValueDecimal) then;
                            end;
                        end else
                            if ltJsonObjectbuill.Add(DelChr(LowerCase(ltField.FieldName), '=', '_-&%(). '), format(ltFieldRef.Value)) then;
                    end;

                until APIMappingLine.Next() = 0;
            end;
            ltRecordRef.Close();

            CLEAR(ltJsonArray);
            CLEAR(ltFieldRef);

            ltRecordRef.Open(pSubTableID);
            ltFieldRef := ltRecordRef.FieldIndex(1);
            ltFieldRef.SetRange(pDocumentType);
            ltFieldRef := ltRecordRef.FieldIndex(2);
            ltFieldRef.SetRange(documentNo);
            if ltRecordRef.FindFirst() then begin
                repeat
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
                                ltFieldRef := ltRecordRef.Field(ltField."No.");
                                if ltField.Type in [ltField.Type::Decimal, ltField.Type::Integer] then begin
                                    if ltField.Type = ltField.Type::Integer then begin
                                        Evaluate(ValueInteger, format(ltFieldRef.Value));
                                        if ltJsonObject.Add(DelChr(LowerCase(ltField.FieldName), '=', '_-&%(). '), ValueInteger) then;
                                    end else begin
                                        Evaluate(ValueDecimal, format(ltFieldRef.Value));
                                        if ltJsonObject.Add(DelChr(LowerCase(ltField.FieldName), '=', '_-&%(). '), ValueDecimal) then;
                                    end;
                                end else
                                    if ltJsonObject.Add(DelChr(LowerCase(ltField.FieldName), '=', '_-&%(). '), format(ltFieldRef.Value)) then;
                            end;

                        until APIMappingLine.Next() = 0;
                    CLEAR(ltJsonObjectReserve);

                    //  CLEAR(ltJsonArrayReserve);
                    ltFieldRef := ltRecordRef.FieldIndex(3);
                    Evaluate(ltLineNo, format(ltFieldRef.Value));
                    ReservationEntry.reset();
                    ReservationEntry.SetRange("Source ID", documentNo);
                    ReservationEntry.SetRange("Source Ref. No.", ltLineNo);
                    if ReservationEntry.FindSet() then begin
                        repeat
                            CLEAR(ltJsonObjectReserve);
                            ltJsonObjectReserve.Add('quantity', ReservationEntry.Quantity);
                            ltJsonObjectReserve.Add('lotno', ReservationEntry."Lot No.");
                            ltJsonObjectReserve.Add('serialno', ReservationEntry."Serial No.");
                            ltJsonArrayReserve.Add(ltJsonObjectReserve);
                        until ReservationEntry.Next() = 0;
                        ltJsonObject.Add('reservelines', ltJsonArrayReserve);
                    end;
                    ltJsonArray.Add(ltJsonObject);
                until ltRecordRef.next = 0;

                ltRecordRef.Close();
            end;
        end;
        ltJsonObjectbuill.Add('detail', ltJsonArray);
        ltJsonArraybuill.Add(ltJsonObjectbuill);

        ltResult.Add(pApiName, ltJsonArraybuill);
        ltResult.WriteTo(ltText);
        ltText := ltText.Replace('"', '\"');
        ltText := ltText.Replace('\"' + pApiName + '\":', '"' + pApiName + '":"');
        ltText := COPYSTR(ltText, 1, StrLen(ltText) - 1) + '"}';
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
    procedure ExportJsonFormat(pPageNO: Integer; pTableID: Integer; pApiName: Text; pPageName: Integer; pDocumentNo: Text)
    var

        APIMappingLine: Record "API Setup Line";
        ltField: Record Field;
        ltJsonObject, ltResult : JsonObject;
        ltJsonArray: JsonArray;
        ltFieldRef: FieldRef;
        ltRecordRef: RecordRef;
        ltText: Text;
        tempBlob: Codeunit "Temp Blob";
        ltOutStr: OutStream;
        ltInstr: InStream;
        ltFileName: Text;
        ValueDecimal: Decimal;
        ValueInteger: Integer;
    begin

        ltRecordRef.Open(pTableID);
        if pDocumentNo <> '' then begin
            if not (pTableID in [81, 83]) then
                ltFieldRef := ltRecordRef.FieldIndex(1)
            else
                ltFieldRef := ltRecordRef.Field(7);
            ltFieldRef.SetFilter(pDocumentNo);
        end;
        if ltRecordRef.FindFirst() then begin
            CLEAR(ltJsonObject);
            CLEAR(ltJsonArray);
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
                                if ltJsonObject.Add(DelChr(LowerCase(ltField.FieldName), '=', '_-&%(). '), ValueInteger) then;
                            end else begin
                                Evaluate(ValueDecimal, format(ltFieldRef.Value));
                                if ltJsonObject.Add(DelChr(LowerCase(ltField.FieldName), '=', '_-&%(). '), ValueDecimal) then;
                            end;
                        end else
                            if ltJsonObject.Add(DelChr(LowerCase(ltField.FieldName), '=', '_-&%(). '), format(ltFieldRef.Value)) then;
                    end;

                until APIMappingLine.Next() = 0;
                ltJsonArray.Add(ltJsonObject);
            end;
        end;
        ltResult.Add(pApiName, ltJsonArray);
        ltResult.WriteTo(ltText);
        ltText := ltText.Replace('"', '\"');
        ltText := ltText.Replace('\"' + pApiName + '\":', '"' + pApiName + '":"');
        ltText := COPYSTR(ltText, 1, StrLen(ltText) - 1) + '"}';
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


}
