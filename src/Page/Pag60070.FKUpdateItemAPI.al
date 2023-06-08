page 60070 "FK Update Item API"
{
    APIGroup = 'bc';
    APIPublisher = 'freshket';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'Update Item API';
    DelayedInsert = true;
    EntityName = 'updateitem';
    EntitySetName = 'updateitems';
    PageType = API;
    SourceTable = "item buffer";
    DeleteAllowed = false;
    ODataKeyFields = "No.";
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('no', Rec."No.");
                    end;
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('description', Rec.Description);
                    end;
                }
                field(searchDescription; Rec."Search Description")
                {
                    Caption = 'Search Description';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('searchDescription', Rec."Search Description");
                    end;
                }
                field(baseUnitOfMeasure; Rec."Base Unit of Measure")
                {
                    Caption = 'Base Unit of Measure';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('baseUnitOfMeasure', Rec."Base Unit of Measure");
                    end;
                }
                field("type"; Rec."Type")
                {
                    Caption = 'Type';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('type', format(Rec.Type));
                    end;
                }
                field(inventoryPostingGroup; Rec."Inventory Posting Group")
                {
                    Caption = 'Inventory Posting Group';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('inventoryPostingGroup', Rec."Inventory Posting Group");
                    end;
                }
                field(genProdPostingGroup; Rec."Gen. Prod. Posting Group")
                {
                    Caption = 'Gen. Prod. Posting Group';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('genProdPostingGroup', Rec."Gen. Prod. Posting Group");
                    end;
                }
                field(vatProdPostingGroup; Rec."VAT Prod. Posting Group")
                {
                    Caption = 'VAT Prod. Posting Group';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('vatProdPostingGroup', Rec."VAT Prod. Posting Group");
                    end;
                }
                field(salesUnitOfMeasure; Rec."Sales Unit of Measure")
                {
                    Caption = 'Sales Unit of Measure';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('salesUnitOfMeasure', Rec."Sales Unit of Measure");
                    end;
                }
                field(purchUnitOfMeasure; Rec."Purch. Unit of Measure")
                {
                    Caption = 'Purch. Unit of Measure';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('purchUnitOfMeasure', Rec."Purch. Unit of Measure");
                    end;
                }
                field(itemCategoryCode; Rec."Item Category Code")
                {
                    Caption = 'Item Category Code';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('itemCategoryCode', Rec."Item Category Code");
                    end;
                }
                field(itemTrackingCode; Rec."Item Tracking Code")
                {
                    Caption = 'Item Tracking Code';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('itemTrackingCode', Rec."Item Tracking Code");
                    end;
                }
                field(expirationCalculation; Rec."Expiration Calculation")
                {
                    Caption = 'Expiration Calculation';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('expirationCalculation', format(Rec."Expiration Calculation"));
                    end;
                }
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        FKFunc: Codeunit "FK Func";
        ltITem: record Item;
    begin
        FKFunc.APITempToTable(Database::item, page::"FK Item API", Rec, rec."No.", 1, 'ITEM', gvJsonObject);
        if ltITem.GET(rec."No.") then
            rec.TransferFields(ltITem, false);
    end;

    var
        gvJsonObject: JsonObject;
}
