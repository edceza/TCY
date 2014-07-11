{*********************************************************************
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * Autor: Brovin Y.D.
 * E-mail: y.brovin@gmail.com
 *
 ********************************************************************}

unit FGX.VirtualKeyboard.Types;

interface

uses
  System.Classes, System.SysUtils;

type

 { TfgButtonsCollection }

  TfgButtonsCollectionItem = class;

  TfgButtonsCollection = class (TCollection)
  protected
    FOwner: TPersistent;
    FOnChanged: TProc;
    function GetOwner: TPersistent; override;
    procedure DoChanged;
    procedure Notify(Item: TCollectionItem; Action: TCollectionNotification); override;
  public
    constructor Create(const AOwner: TPersistent; const AOnChanged: TProc);
    function GetButton(const Index: Integer): TfgButtonsCollectionItem;
  end;

  { TfgButtonsCollectionItem }

  TfgButtonsCollectionItem = class (TCollectionItem)
  private
    procedure SetCaption(const Value: string);
    procedure SetOnClick(const Value: TNotifyEvent);
    procedure SetVisible(const Value: Boolean);
  protected
    FCaption: string;
    FVisible: Boolean;
    FOnChanged: TProc;
    FOnClick: TNotifyEvent;
    procedure AssignTo(Dest: TPersistent); override;
    function Collection: TfgButtonsCollection; virtual;
    function GetDisplayName: string; override;
    procedure NotifyAboutChanges; virtual;
  public
    constructor Create(Collection: TCollection); override;
    property OnChanged: TProc read FOnChanged write FOnChanged;
  published
    property Caption: string read FCaption write SetCaption;
    property Visible: Boolean read FVisible write SetVisible default True;
    property OnClick: TNotifyEvent read FOnClick write SetOnClick;
  end;

implementation

uses
  System.Math;

{ TfgButtonsCollection }

constructor TfgButtonsCollection.Create(const AOwner: TPersistent; const AOnChanged: TProc);
begin
  inherited Create(TfgButtonsCollectionItem);
  FOwner := AOwner;
  FOnChanged := AOnChanged;
end;

procedure TfgButtonsCollection.DoChanged;
begin
  if Assigned(FOnChanged) then
    FOnChanged;
end;

function TfgButtonsCollection.GetButton(const Index: Integer): TfgButtonsCollectionItem;
begin
  Assert(InRange(Index, 0, Count - 1));
  Result := Items[Index] as TfgButtonsCollectionItem;
end;

function TfgButtonsCollection.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TfgButtonsCollection.Notify(Item: TCollectionItem; Action: TCollectionNotification);
begin
  Assert(Item is TfgButtonsCollectionItem);
  inherited Notify(Item, Action);
  if Action = TCollectionNotification.cnAdded then
    (Item as TfgButtonsCollectionItem).OnChanged := DoChanged;
  DoChanged;
end;

{ TfgButtonsCollectionItem }

procedure TfgButtonsCollectionItem.AssignTo(Dest: TPersistent);
var
  DestAction: TfgButtonsCollectionItem;
begin
  if Dest is TfgButtonsCollectionItem then
  begin
    DestAction := Dest as TfgButtonsCollectionItem;
    DestAction.Caption := Caption;
    DestAction.OnClick := OnClick;
    DestAction.Visible := Visible;
  end
  else
    inherited AssignTo(Dest);
end;

function TfgButtonsCollectionItem.Collection: TfgButtonsCollection;
begin
  Assert(Collection <> nil);
  Result := Collection as TfgButtonsCollection;
end;

constructor TfgButtonsCollectionItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FVisible := True;
end;

function TfgButtonsCollectionItem.GetDisplayName: string;
begin
  if Caption.IsEmpty then
    Result := inherited GetDisplayName
  else
    Result := Caption;
end;

procedure TfgButtonsCollectionItem.NotifyAboutChanges;
begin
  if Assigned(FOnChanged) then
    FOnChanged;
end;

procedure TfgButtonsCollectionItem.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    NotifyAboutChanges;
  end;
end;

procedure TfgButtonsCollectionItem.SetOnClick(const Value: TNotifyEvent);
begin
  FOnClick := Value;
  NotifyAboutChanges;
end;

procedure TfgButtonsCollectionItem.SetVisible(const Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    NotifyAboutChanges;
  end;
end;

end.
