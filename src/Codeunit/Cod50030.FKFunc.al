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
        ltJsonObject, ltJsonObjectDetail, ltJsonObject2, JsonObjectSelect : JsonObject;
        ltJsonToken, ltJsonToken2, ltJsonTokenDetail : JsonToken;
        ltJsonArray, ltJsonArrayDetail : JsonArray;
        ltmyLoop: Integer;
        JSONManagement: Codeunit "JSON Management";
        CustomerJsonObject: text;
        PageControl: Record "Page Control Field";
        ltFieldRef: FieldRef;
        ltRecordRef: RecordRef;
        ltField: Record Field;
    begin
        ltJsonToken.ReadFrom(Format(customerlists).Replace('\', ''));
        ltJsonArray := ltJsonToken.AsArray();
        foreach ltJsonToken2 in ltJsonArray do begin
            ltJsonObject2 := ltJsonToken2.AsObject();
            ltJsonObject2.SelectToken('$.detail', ltJsonToken2);
            ltJsonArrayDetail := ltJsonToken2.AsArray();
            foreach ltJsonTokenDetail in ltJsonArrayDetail do begin
                ltJsonObjectDetail := ltJsonTokenDetail.AsObject();
                ERROR(SelectJsonTokenText(ltJsonObjectDetail, '$.nos'));
            end;
        end;
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
    procedure ExportJsonFormatMuntitable(pPageNO: Integer; pPageNOSubform: Integer; pDocumentType: Enum "Sales Document Type"; pApiName: Text; pPageName: Integer; pTableID: Integer; pSubTableID: Integer; pDocumentNo: Text)
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
}
